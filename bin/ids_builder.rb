# frozen_string_literal: true

require 'yaml'
require_relative 'ids_commons'
require_relative 'ids_diagnosis_person'
require_relative 'ids_patient_history'
require_relative 'rds_end'
require_relative 'ids_person_address'
require_relative 'ids_vitals'
require_relative 'ids_patient_symptoms'
require_relative 'ids_presenting_complaints'
require_relative 'ids_side_effects'
require_relative 'ids_tb_statuses'
require_relative 'ids_family_planning'
require_relative 'ids_lab_orders'
require_relative 'ids_staging_info'
require_relative 'ids_prescription_has'
require_relative 'ids_relationship'
require_relative 'ids_pregnant_status'
require_relative 'ids_breastfeeding_status'
require_relative 'ids_people'
require_relative 'ids_lab_test_results'
require_relative 'ids_appointment'
require_relative 'ids_tb_statuses'
require_relative 'ids_prescription'
require_relative 'ids_outcomes'

@rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']
File.open("#{Rails.root}/log/last_update.yml", 'w') unless File.exist?("#{Rails.root}/log/last_update.yml") # Create a tracking file if it does not exist
@last_updated = YAML.load_file("#{Rails.root}/log/last_update.yml")
@batch_size = 10_000
@threshold = 85

def get_all_rds_peoples
  last_updated = get_last_updated('Person')

  rds_people = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person WHERE updated_at >= '#{last_updated}' ORDER BY updated_at;
QUERY
  rds_people
end

def get_rds_person_name(person_id)
  last_updated = get_last_updated('PersonName')
  person_name = []
  rds_person_name = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_name where person_id = #{person_id};
QUERY
  rds_person_name.each { |name| person_name << name }
end

def get_rds_person_addresses(person_id)
  last_updated = get_last_updated('PersonAddress')
  person_address = []
  rds_address = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_address where person_id = #{person_id};
QUERY

  rds_address.each { |address| person_address << address }
end

def get_rds_person_attributes
  last_updated = get_last_updated('PersonAttribute')
  person_attribute = []
  rds_attribute = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_attribute WHERE person_attribute_type_id IN (12,14,15)
	AND (updated_at >= '#{last_updated};

QUERY

  rds_attribute.each { |attribute| person_attribute << attribute }
end

def get_rds_users
  if @last_updated.include?('Users')
    @last_updated['Users'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['Users']
  else
    last_updated = '1900-01-01 00:00:00'
  end

  rds_users = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.users where updated_at >= '#{last_updated}'
	order by updated_at;

QUERY
end

def find_duplicates(subject, subject_person_id)
  ActiveRecord::Base.connection.select_all <<QUERY
			SELECT person_id, ROUND(CAST((((length("#{subject}") - damlev(person_de_duplicator,"#{subject}"))/ length("#{subject}")) * 100) AS DECIMAL),2)
 as score FROM de_duplicators WHERE person_id != #{subject_person_id} HAVING score >= #{@threshold};
QUERY
end

def process_duplicates(duplicates, duplicate_id)
  duplicates.each do |duplicate|
      # save to duplicate_statuses
      PotentialDuplicate.create(person_id_a: duplicate_id, person_id_b: duplicate['person_id'], score: duplicate['score'].to_f)
  end
end

def check_for_duplicate(demographics)
  # find matching text in de_duplicator table

  subject = ''
  subject += demographics[:person_names][0]['given_name'] rescue  ''
  subject << demographics[:person_names][0]['family_name'] rescue  ''
  subject <<  demographics[:person]['gender'] rescue  nil
  subject <<  demographics[:person]['birthdate'].strftime('%Y-%m-%d').gsub('-', '') rescue ''
  subject <<  demographics[:person_address][0]['address2'] rescue  ''
  subject <<  demographics[:person_address][0]['county_district'] rescue  ''
  subject <<  demographics[:person_address][0]['neighborhood_cell'] rescue  ''
  subject.gsub!(/\s+/, '')
  
  duplicates = find_duplicates(subject, demographics[:person]['person_id'])

  person_present = DeDuplicator.find_by(person_id: demographics[:person]['person_id'])
  if person_present
    puts 'person_present'
    person_present.update(person_de_duplicator: subject)
  else
    DeDuplicator.create(person_id: demographics[:person]['person_id'], person_de_duplicator: subject)
    begin
      puts duplicates.first['score'].to_f.inspect
    rescue StandardError
      nil
    end
  end
  process_duplicates(duplicates, demographics[:person]['person_id']) unless duplicates.blank?
end

def populate_people
  last_updated = get_last_updated('People')
  query = "SELECT * FROM #{@rds_db}.person WHERE updated_at >= '#{last_updated}' "

  fetch_data(query) do |person|
   ids_people(person)
  end
end

def update_last_update(model, timestamp)
  current_update_date = YAML.load_file("#{Rails.root}/log/last_update.yml") || {}
  current_update_date[model] = begin
    timestamp.strftime('%Y-%m-%d %H:%M:%S')
                               rescue StandardError
                                 nil
  end
  File.open('log/last_update.yml', 'w') do |file|
    file.write current_update_date.to_yaml
  end
end

def initiate_de_duplication
  last_updated = get_last_updated('Deduplicaton')

  query = "SELECT * FROM #{@rds_db}.person WHERE updated_at >= '#{last_updated}' "

  fetch_data(query) do |person|
    demographics = {}
    demographics = { "person": person }
    demographics.update("person_names": get_rds_person_name(person['person_id']))
    demographics.update("person_address": get_rds_person_addresses(person['person_id']))

    check_for_duplicate(demographics)

    update_last_update('Deduplicaton', person['updated_at'])
  end
end

def populate_person_names
  last_updated = get_last_updated('PersonNames')

  query = "SELECT * FROM #{@rds_db}.person_name WHERE person_name_id 
           IN #{load_error_records('person_name')} OR updated_at >= '#{last_updated}' "

  fetch_data(query) do |person_name|
    puts "Updating Person Name for person_id: #{person_name['person_id']}"
    person_name_exist = PersonName.find_by(
      person_name_id: person_name['person_name_id']
    )
  
    if person_name_exist.blank?
      begin
        PersonName.create(
          person_name_id: person_name['person_name_id'],
          person_id: person_name['person_id'],
          given_name: person_name['given_name'],
          family_name: person_name['family_name'],
          middle_name: person_name['middle_name'],
          maiden_name: person_name['maiden_name'],
          creator: person_name['creator'],
          voided: person_name['voided'],
          voided_by: person_name['voided_by'],
          void_reason: person_name['void_reason'],
          app_date_created: person_name['date_created'],
          app_date_updated: person_name['date_updated']
        )
          remove_failed_record('person_name', person_name['person_name_id']) 

      rescue Exception => e
        log_error_records('person_name', person_name['person_name_id'].to_i, e)
      end
    elsif ((person_name['date_changed'].strftime('%Y-%m-%d %H:%M:%S') rescue nil) ||
        person_name['date_created'].strftime('%Y-%m-%d %H:%M:%S')) >
      (person_name_exist.app_date_updated.strftime('%Y-%m-%d %H:%M:%S') rescue 'NULL')
      person_name_exist.update(
        person_name_id: person_name['person_name_id'],
        person_id: person_name['person_id'],
        given_name: person_name['given_name'],
        family_name: person_name['family_name'],
        middle_name: person_name['middle_name'],
        maiden_name: person_name['maiden_name'],
        creator: person_name['creator'], voided:
        person_name['voided'],
        voided_by: person_name['voided_by'],
        void_reason: person_name['void_reason'],
        app_date_created: person_name['date_created'],
        app_date_updated: person_name['date_updated']
      )
    end
    update_last_update('PersonName', person_name['updated_at'])
  end
end

def populate_contact_details
  last_updated = get_last_updated('PersonAttribute')

  (get_rds_person_attributes || []).each do |person_attribute|
    attribute_value = person_attribute['value']

    cell_phone_number = ''
    home_phone_number = ''
    work_phone_number = ''

    case person_attribute['person_attribute_type_id']

    when 12
      cell_phone_number = attribute_value
    when 14
      home_phone_number = attribute_value
    when 15
      work_phone_number = attribute_value

      # TODO: Add email address code
      # email_address to be added when applications having email addresses start pushing to IDS
    end

    puts "processing person_id #{person_attribute['person_id']}"

    person = Person.find_by(person_id: person_attribute['person_id'])

    if person
      if ContactDetail.find_by(person_id: person_attribute['person_id']).blank?
        contact_detail = ContactDetail.new
        contact_detail.person_id = person_attribute['person_id']
        contact_detail.home_phone_number = home_phone_number
        contact_detail.cell_phone_number = cell_phone_number
        contact_detail.work_phone_number = work_phone_number
        contact_detail.creator = person_attribute['creator']
        contact_detail.voided = person_attribute['voided']
        contact_detail.voided_by = person_attribute['voided_by']
        contact_detail.voided_date = person_attribute['date_voided']
        contact_detail.void_reason = person_attribute['void_reason']
        contact_detail.created_at = Date.today.strftime('%Y-%m-%d %H:%M:%S')
        contact_detail.updated_at = Date.today.strftime('%Y-%m-%d %H:%M:%S')
        contact_detail.app_date_created = person_attribute['date_created']

        contact_detail.save

        puts "Successfully populated contact details with record for person #{person_attribute['person_id']}"
      else
        contact_detail = ContactDetail.where(person_id: person_attribute['person_id'])
        contact_detail.update(home_phone_number: '') unless home_phone_number.nil?
        contact_detail.update(cell_phone_number: '') unless cell_phone_number.nil?
        contact_detail.update(work_phone_number: '') unless work_phone_number.nil?
        contact_detail.update(creator: person_attribute['creator'])
        contact_detail.update(voided: person_attribute['voided'])
        contact_detail.update(voided_by: person_attribute['voided_by'])
        contact_detail.update(voided_date: person_attribute['date_voided'])
        contact_detail.update(void_reason: person_attribute['void_reason'])
        contact_detail.update(created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))
        contact_detail.update(updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

        puts "Successfully updated contact details with record for person #{person_attribute['person_id']}"
      end
    else
      puts '==================================================================='
      puts "Skipped record for Person with ID #{person_attribute['person_id']}"
      puts 'Reason: Person records for the above ID not available in People'
      puts '==================================================================='
      puts ''
      puts 'Ending script'
      break
    end
    # Updating last record processed
      update_last_update('PersonAttribute', person_attribute['updated_at'])
  end
end

def populate_encounters
  last_updated = get_last_updated('Encounter')

  query = "SELECT * FROM #{@rds_db}.encounter 
           WHERE updated_at >= '#{last_updated}'
           OR encounter_id IN #{load_error_records('encounter')}"

    fetch_data(query) do |rds_encounter|
      puts "processing Encounters for person_id #{rds_encounter['patient_id']}"
      rds_prog_id = rds_encounter['program_id']
      program_name = ActiveRecord::Base.connection.select_all <<SQL
    SELECT name FROM #{@rds_db}.program  WHERE program_id = #{rds_prog_id} limit 1
SQL
      rds_encounter_type_id = rds_encounter['encounter_type']
      rds_encounter_type = ActiveRecord::Base.connection.select_all <<SQL
    SELECT name FROM #{@rds_db}.encounter_type WHERE encounter_type_id = #{rds_encounter_type_id} limit 1
SQL
      ids_encounter_type_name = rds_encounter_type.first
      ids_prog_name = program_name.first
      master_definition_prog_id = MasterDefinition.find_by(definition: ids_prog_name['name'])

      master_definition_encounter_id = MasterDefinition.find_by(definition: ids_encounter_type_name['name'])

      if Encounter.find_by(encounter_id: rds_encounter['encounter_id']).blank?
        begin
          encounter = Encounter.new
          encounter.encounter_id = rds_encounter['encounter_id']
          encounter.encounter_type_id = master_definition_encounter_id['master_definition_id']
          encounter.program_id = master_definition_prog_id['master_definition_id']
          encounter.person_id = rds_encounter['patient_id']
          encounter.visit_date = rds_encounter['encounter_datetime']
          encounter.voided = rds_encounter['voided']
          encounter.voided_by = rds_encounter['voided_by']
          encounter.voided_date = rds_encounter['date_voided']
          encounter.void_reason = rds_encounter['void_reason']
          encounter.app_date_created = rds_encounter['date_created']
          encounter.app_date_updated = rds_encounter['date_changed']

          if encounter.save
            puts "Successfully populated encounter with record for person #{rds_encounter['patient_id']}encounter id " \
                 "#{rds_encounter['encounter_id']}"
            remove_failed_record('encounter', rds_encounter['encounter_id'].to_i)
          end
        rescue Exception => e
          log_error_records('encounter', rds_encounter['encounter_id'].to_i, e)
        end
      else
        encounter = Encounter.find_by(
          encounter_id: rds_encounter['encounter_id']
        )
        date_updated = rds_encounter['date_changed'] || rds_encounter['date_created']

        date_updated = date_updated.strftime('%Y-%m-%d %H:%M:%S')

        if encounter && date_updated  > (encounter.app_date_updated.strftime('%Y-%m-%d %H:%M:%S') rescue 'NULL')
          encounter.update(encounter_type_id: master_definition_encounter_id['master_definition_id'],
                            program_id: master_definition_prog_id['master_definition_id'],
                            person_id: rds_encounter['patient_id'], visit_date: rds_encounter['encounter_datetime'],
                            voided: rds_encounter['voided'], voided_by: rds_encounter['voided_by'],
                            voided_date: rds_encounter['date_voided'], void_reason: rds_encounter['void_reason'],
                            app_date_updated: rds_encounter['date_changed'],
                            created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'), updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S')) 
          puts "Successfully updated encounter details with record for person #{rds_encounter['patient_id']} encounter id " \
               "#{rds_encounter['encounter_id']} "
        end
      end
      # Updating last record processed
      update_last_update('Encounter', rds_encounter['updated_at'])
    end
end

def populate_users
  # person_id, username, user_role
  get_rds_users.each do |rds_user|
    person = Person.find_by(person_id: rds_user['person_id'])

    # TODO: code for getting all people skipping user, to talk about this
    if person
      if User.find_by(person_id: rds_user['person_id']).blank?
        user = User.new
        user.person_id = rds_user['person_id']
        user.username = rds_user['username']
        user.password = rds_user['password']
        user.user_role = ''
        user.save
      end
    else
      puts '==================================================================='
      puts "Skipped record for User with ID #{rds_user['person_id']}"
      puts 'Reason: Person records for the above ID not available in People'
      puts '==================================================================='
      puts ''
      puts 'Ending script'
      break
    end
  end
end

def get_last_updated(model)
  if @last_updated
    if @last_updated.include?(model)
      @last_updated[model].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated[model]
    else
      last_updated = '1900-01-01 00:00:00'
    end
  else
    last_updated = '1900-01-01 00:00:00'
  end
end

def update_person_type
  # Updating users type in person_type table
  last_updated = get_last_updated('User')

query = "SELECT * FROM #{@rds_db}.users WHERE updated_at >= '#{last_updated}'
         OR user_id IN #{load_error_records('user')} "

  person_type_id = 4 # person type id for user
  fetch_data(query) do |user|
    puts "processing user with person_id #{user['person_id'] || user['patient_id']}"
    person_has_type(person_type_id, user)

    update_last_update('User', user['updated_at'])
  end

  # Updating Guardians in person type table
  last_updated = get_last_updated('Relationship')

  query = "SELECT * FROM #{@rds_db}.relationship WHERE relationship = 6 AND
           updated_at >= '#{last_updated}' 
           OR relationship_id IN #{load_error_records('guardian')} "

  person_type_id = 5 # person type id for guardian
  fetch_data(query) do |guardian|
    puts "Processing guardian with person_id #{guardian['person_b']} "
    person_has_type(person_type_id, guardian)
    update_last_update('Relationship', guardian['updated_at'])
  end

  # Updating Patients in person type table
  last_updated = get_last_updated('Patient')

  query = "SELECT * FROM #{@rds_db}.patient WHERE updated_at >= '#{last_updated}'
           OR patient_id IN #{load_error_records('user')} "

  person_type_id = 1 # person type id for patient
  fetch_data(query) do |patient|
    puts "Processing patient with person_id #{patient['person_id'] || patient['patient_id']}"
    person_has_type(person_type_id, patient)
    update_last_update('Patient', patient['updated_at'])
  end

  # Updating Provider in person type table
  last_updated = get_last_updated('Patient')

  query = "SELECT * FROM #{@rds_db}.users WHERE updated_at >= '#{last_updated}'
           OR user_id IN #{load_error_records('user')} "

  person_type_id = 2 # person type id for provider
  fetch_data(query) do |provider|
    puts "Processing provider with person_id #{provider['person_id'] || provider['patient_id']}"
    person_has_type(person_type_id, provider)
    update_last_update('Provider', provider['updated_at'])
  end
end

def populate_diagnosis
  last_updated = get_last_updated('Diagnosis')

  primary_diagnosis = 6542
  secondary_diagnosis = 6543

query = "SELECT * FROM #{@rds_db}.obs ob
  INNER JOIN #{@rds_db}.encounter en
  ON ob.encounter_id = en.encounter_id
  WHERE ob.concept_id IN (6542,6543)
  AND ob.updated_at >= '#{last_updated}' "

  fetch_data(query) do |diag|
    ids_diagnosis_person(diag, primary_diagnosis, secondary_diagnosis)
  end
end

def get_district_id(district)
  Location.find_by(name: district)['location_id'].to_i
end

def populate_vitals
   last_updated = get_last_updated('Vital')

   query = "SELECT ob.* FROM #{@rds_db}.obs ob
            INNER JOIN #{@rds_db}.encounter en
            ON ob.encounter_id = en.encounter_id
            WHERE (encounter_type = 6
            AND ob.updated_at >= '#{last_updated}') 
            OR ob.obs_id IN #{load_error_records('vitals')} "
   
   fetch_data(query) do |vitals|
    vital_value_coded(vitals)
  end
end

def categorize_address(addresses)
  address_types = { 'home_address' => { 'home_district' => '', 'home_ta' => '', 'home_village' => '' }, 'current_address' =>
      { 'current_district' => '', 'current_ta' => '', 'current_village' => '' } }
  addresses.each do |key, value|
    address_types['home_address'].merge!('home_district' => value.to_s) if key == 'address2'
    address_types['home_address'].merge!('home_ta' => value.to_s) if key == 'county_district'
    address_types['home_address'].merge!('home_village' => value.to_s) if key == 'neigborhood_cell'
    address_types['current_address'].merge!('current_district' => value.to_s) if key == 'state_province'
    address_types['current_address'].merge!('current_ta' => value.to_s) if key == 'township_division'
    address_types['current_address'].merge!('current_village' => value.to_s) if key == 'city_village'
  end
  address_types
end

def get_master_def_id(openmrs_metadata_id, openmrs_entity_name)
  MasterDefinition.where(openmrs_metadata_id: openmrs_metadata_id).where(openmrs_entity_name: openmrs_entity_name).first.master_definition_id
rescue StandardError
  nil
end

def populate_pregnant_status
  last_updated = get_last_updated('PregnantStatus')

  query = "SELECT * FROM #{@rds_db}.obs 
           WHERE (concept_id in (1755,6131) 
           AND updated_at >= '#{last_updated}')
           OR obs_id IN #{load_error_records('pregnant_status')} "

  fetch_data(query) do |pregnant_status|
    ids_pregnant_status(pregnant_status)
  end
end

def populate_breastfeeding_status
  last_updated = get_last_updated('BreastfeedingStatus')

  query = "SELECT * FROM #{@rds_db}.obs WHERE (concept_id IN
           (834,5253,5579,5632,8040,5632,9538) AND updated_at >= '#{last_updated}')
           OR obs_id IN #{load_error_records('breastfeeding_status')} "

  fetch_data(query) do |status|
    ids_breastfeeding_status(status)
  end
end

def populate_person_address
  last_updated = get_last_updated('PersonAddress')
  
  query = "SELECT * FROM #{@rds_db}.person_address WHERE
           person_address_id IN #{load_error_records('person_address')} OR
           updated_at >= '#{last_updated}' "

  fetch_data(query) do |person_address|
    grouped_address(person_address)
  end
end

def populate_patient_history
  last_updated = get_last_updated('PatientHistory')

  query = "SELECT ob.* FROM #{@rds_db}.obs ob
           INNER JOIN #{@rds_db}.encounter en
           ON ob.encounter_id = en.encounter_id 
           INNER JOIN #{@rds_db}.encounter_type et
           ON en.encounter_type = et.encounter_type_id
           WHERE et.encounter_type_id 
           IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type WHERE name like '%history%')
           OR obs_id IN #{load_error_records('patient_history')} OR
           ob.updated_at >= '#{last_updated}' "

   fetch_data(query) do |patient_history|
     ids_patient_history(patient_history)
   end
end

def populate_symptoms
  last_updated = get_last_updated('Symptom')

  query = "SELECT ob.* FROM #{@rds_db}.obs ob
           INNER JOIN #{@rds_db}.encounter en
           ON ob.encounter_id = en.encounter_id 
           INNER JOIN #{@rds_db}.encounter_type et
           ON en.encounter_type = et.encounter_type_id
           WHERE et.encounter_type_id 
           IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type WHERE name like '%symptoms')
           OR obs_id IN #{load_error_records('symptoms')} OR
           ob.updated_at >= '#{last_updated}' "

  fetch_data(query) do |patient_symptoms|
    ids_patient_symptoms(patient_symptoms)
  end       
end

def populate_side_effects
  last_updated = get_last_updated('SideEffects')

   query = "SELECT ob.* FROM #{@rds_db}.obs ob
            WHERE concept_id IN 
            (SELECT concept_id FROM #{@rds_db}.concept_name WHERE name like '%side%')
            OR obs_id IN #{load_error_records('side_effects')} 
            OR ob.updated_at >= '#{last_updated}' "

  fetch_data(query) do |patient_side_effect|
    ids_side_effects(patient_side_effect)
  end
end

def populate_presenting_complaints
  last_updated = get_last_updated('PresentingComplaints')

   query = "SELECT ob.* FROM #{@rds_db}.obs ob
           INNER JOIN #{@rds_db}.encounter en
           ON ob.encounter_id = en.encounter_id
           INNER JOIN #{@rds_db}.encounter_type et
           ON en.encounter_type = et.encounter_type_id
           WHERE et.encounter_type_id = 122
           OR obs_id IN #{load_error_records('presenting_complaints')}
           OR ob.updated_at >= '#{last_updated}' "
    
    fetch_data(query) do |record|
    ids_presenting_complaints(record)
  end
end

def populate_tb_statuses
  last_updated = get_last_updated('TbStatus')

   query = "SELECT ob.* FROM #{@rds_db}.obs ob
            WHERE (concept_id = 7459 
            OR ob.updated_at >= '#{last_updated}')
            OR obs_id IN #{load_error_records('tb_status')} "
    
    fetch_data(query) do |record|
    ids_tb_statuses(record)
  end
end

def populate_family_planning
  last_updated = get_last_updated('FamilyPlanning')

   query = "SELECT * FROM #{@rds_db}.obs ob
            WHERE (concept_id IN
            (SELECT concept_id FROM 
            #{@rds_db}.concept_name 
            WHERE name like '%family%')
            AND ob.updated_at >= '#{last_updated}')
            OR obs_id IN #{load_error_records('famiy_planning')} "

    fetch_data(query) do |record|
    ids_family_planning(record)
  end
end

def populate_outcomes
  last_updated = get_last_updated('Outcome')

   query = "SELECT pp.patient_id, pws.* FROM #{@rds_db}.patient_program pp
           INNER JOIN #{@rds_db}.patient_state ps 
           ON pp.patient_program_id = ps.patient_program_id
           INNER JOIN  #{@rds_db}.program_workflow pw 
           ON pp.program_id = pw.program_id
           INNER JOIN #{@rds_db}.program_workflow_state pws 
           ON pw.program_workflow_id = pws.program_workflow_id
           WHERE pp.updated_at >= '#{last_updated}' "
    
    fetch_data(query) do |record|
      ids_outcomes(record)
    end
end

def populate_occupation
  last_updated = get_last_updated('Occupation')

   query = "SELECT * FROM #{@rds_db}.person_attribute 
            WHERE (person_attribute_type_id = 13
            AND updated_at >= '#{last_updated}')
            OR person_attribute_id IN #{load_error_records('occupation')} "

    fetch_data(query) do |record|
      ids_occupation(record)
    end
end
    
  def ids_occupation(rds_occupation)
    puts "processing Occupation for person_id #{rds_occupation['person_id']}"
    occupation_exists = Occupation.find_by(occupation_id: rds_occupation['person_attribute_id'])
    if occupation_exists.blank?
      begin
        person_occupation = Occupation.new
        person_occupation.occupation_id = rds_occupation['person_attribute_id']
        person_occupation.person_id = rds_occupation['person_id']
        person_occupation.occupation = rds_occupation['value']
        person_occupation.creator = rds_occupation['creator']
        person_occupation.voided = rds_occupation['voided']
        person_occupation.voided_by = rds_occupation['voided_by']
        person_occupation.voided_date = rds_occupation['date_voided']
        person_occupation.void_reason = rds_occupation['void_reason']
        person_occupation.app_date_created = rds_occupation['date_created']
        person_occupation.app_date_updated = rds_occupation['date_changed']
        person_occupation.save

        puts "Successfully populated occupation with record for person #{rds_occupation['person_id']}"
          remove_failed_record('occupation', rds_occupation['person_attribute_id'])
      rescue Exception => e
        log_error_records('occupation', rds_occupation['person_attribute_id'].to_i, e)
      end
    elsif check_latest_record(rds_occupation, occupation_exists)
      person_occupation.update(occupation: rds_occupation['value'],
                               creator: rds_occupation['creator'],
                               person_id: rds_occupation['person_id'], voided: rds_occupation['voided'],
                               voided_by: rds_occupation['voided_by'], voided_date: rds_occupation['date_voided'],
                               void_reason: rds_occupation['void_reason'], 
                               app_date_created: rds_occupation['date_created'],
                               app_date_updated: rds_occupation['date_changed']) 

      puts "Successfully updated occupation details with record for person #{rds_occupation['person_id']}"

    end
  end

def populate_appointment
  last_updated = get_last_updated('Appointment')

   query = "SELECT ob.* FROM #{@rds_db}.obs ob 
            JOIN #{@rds_db}.encounter en
            ON ob.encounter_id = en.encounter_id
            WHERE (en.encounter_type = 7
            AND ob.updated_at >= '#{last_updated}')
            OR obs_id IN #{load_error_records('appointment')} "
    
    fetch_data(query) do |record|
      ids_appointment(record)
    end
end

def populate_prescription
  last_updated = get_last_updated('MedicationPrescription')

   query = "SELECT * FROM #{@rds_db}.orders o
            JOIN #{@rds_db}.drug_order d on o.order_id = d.order_id
            WHERE (o.order_type_id = 1       
            AND o.updated_at >= '#{last_updated}') OR 
            o.order_id IN #{load_error_records('prescription')} "
    
    fetch_data(query) do |record|
      ids_prescription(record)
    end
end

def populate_dispensation
  last_updated = get_last_updated('MedicationDispensation')

  query = "SELECT o.order_id, quantity,o.date_created,o.voided,
  o.voided_by,o.date_voided, o.void_reason,o.patient_id, do.updated_at
  FROM #{@rds_db}.orders o
  INNER JOIN #{@rds_db}.drug_order do  ON o.order_id = do.order_id
  WHERE (do.updated_at >= '#{last_updated}')
  OR do.order_id IN #{load_error_records('dispensation')}"
    

  fetch_data(query) do |rds_dispensed_drug|
      puts "Processing dispensation record for person #{rds_dispensed_drug['patient_id']}"

     dispensation_exist = MedicationDispensation.find_by_medication_dispensation_id(rds_dispensed_drug['order_id'])
     if dispensation_exist.blank?
      begin
        MedicationDispensation.create(
          medication_dispensation_id: rds_dispensed_drug['order_id'],
          quantity: rds_dispensed_drug['quantity'],
          medication_prescription_id: rds_dispensed_drug['order_id'],
          voided: rds_dispensed_drug['voided'],
          voided_by: rds_dispensed_drug['voided_by'],
          voided_date: rds_dispensed_drug['date_voided'],
          void_reason: rds_dispensed_drug['void_reason'],
          app_date_created: rds_dispensed_drug['date_created'],
          app_date_updated: ''
          )
         puts "Successfully INSERTED medication dispensation details for person #{rds_dispensed_drug['patient_id']}"

         remove_failed_record('dispensation', rds_dispensed_drug['order_id'].to_i)

      rescue Exception => e
        log_error_records('dispensation', rds_dispensed_drug['order_id'].to_i, e)
      end
     elsif check_latest_record(rds_dispensed_drug, dispensation_exist)
       dispensation_exist.update(
        quantity: rds_dispensed_drug['quantity'],
        medication_prescription_id: ids_prescribed_drug['medication_prescription_id'],
        voided: rds_dispensed_drug['voided'],
        voided_by: rds_dispensed_drug['voided_by'],
        voided_date: rds_dispensed_drug['date_voided'],
        void_reason: rds_dispensed_drug['void_reason'],
        app_date_created: rds_dispensed_drug['date_created'],
        app_date_updated: ''
        )
       puts "Successfully UPDATED medication dispensation details for person #{rds_dispensed_drug['patient_id']}"
     end
    update_last_update('Despensation', rds_dispensed_drug['updated_at'])
  end    
end

def populate_relationships
  last_updated = get_last_updated('Relationship')

  query = "SELECT * from #{@rds_db}.relationship 
           WHERE relationship_id IN #{load_error_records('relationships')} 
           OR updated_at >= '#{last_updated}' "
    
  fetch_data(query) do |record|
    ids_relationship(record)
  end
end

def populate_adherence
  last_updated = get_last_updated('MedicationAdherence')
  
  query = "SELECT * FROM medication_prescriptions"

  fetch_data(query) do |ids_prescribed_drug|
    drug_dispensed_id = ids_prescribed_drug['drug_id'].to_i # we need to include an order id which is a unique and we will need to compare in obs table
    prescription_drug_adherence = ActiveRecord::Base.connection.select_all <<SQL
      SELECT oo.obs_id, oo.person_id,oo.value_text AS adherence_in_percentage, 
      date(oo.obs_datetime) as visit_date,dg.drug_id as rds_drug_id,
      oo.date_created, oo.updated_at
      FROM #{@rds_db}.obs oo
      LEFT JOIN #{@rds_db}.orders o ON oo.order_id = o.order_id
      LEFT JOIN #{@rds_db}.drug_order d ON o.order_id = d.order_id
      LEFT JOIN #{@rds_db}.drug dg ON d.drug_inventory_id = dg.drug_id
      WHERE oo.concept_id = 6987 and dg.drug_id = #{drug_dispensed_id};
SQL
    # where clause should read WHERE oo.concept_id = 6987 and ids_prescribed_drug['order_id'] = oo.order_id;
    (prescription_drug_adherence || []).each do |rds_drug_adherence|

      puts "Processing adherence record for person #{rds_drug_adherence['person_id']}"

    adherence_exists = MedicationAdherence.find_by_adherence_id(rds_drug_adherence['obs_id'].to_i)

    if adherence_exists.blank?
      begin
        MedicationAdherence.create(
          adherence_id: rds_drug_adherence['obs_id'].to_i,
          medication_dispensation_id: ids_prescribed_drug['medication_prescription_id'],
          drug_id: ids_prescribed_drug['drug_id'],
          adherence: rds_drug_adherence['adherence_in_percentage'],
          voided: ids_prescribed_drug['voided'],
          voided_by: ids_prescribed_drug['voided_by'], 
          voided_date: ids_prescribed_drug['date_voided'],
          void_reason: ids_prescribed_drug['void_reason'], 
          app_date_created: rds_drug_adherence['date_created'],
          app_date_updated: ids_prescribed_drug['date_changed']
          )

      remove_failed_record('adherence', rds_drug_adherence['obs_id'].to_i)
      
      rescue Exception => e
        log_error_records('adherence', rds_drug_adherence['obs_id'].to_i, e)
      end

    elsif check_latest_record(rds_drug_adherence, adherence_exists)
      adherence_exists.update(
        medication_dispensation_id: ids_prescribed_drug['medication_prescription_id'],
        drug_id: ids_prescribed_drug['drug_id'],
        adherence: rds_drug_adherence['adherence_in_percentage'],
        voided: ids_prescribed_drug['voided'],
        voided_by: ids_prescribed_drug['voided_by'], 
        voided_date: ids_prescribed_drug['date_voided'],
        void_reason: ids_prescribed_drug['void_reason'], 
        app_date_created: rds_drug_adherence['date_created'],
        app_date_updated: ids_prescribed_drug['date_changed']
        )
    end



      puts "Successfully populated medication adherence details with record for person #{rds_drug_adherence['person_id']}"
      update_last_update('Adherence', rds_drug_adherence['updated_at'])
    end    
  end
end

def populate_de_identifier
  last_updated = get_last_updated('PersonNames')

  query = "SELECT * FROM people
  WHERE updated_at >= '#{last_updated}'"

  fetch_data(query) do |person_details|
    person_id_exist = DeIdentifiedIdentifier.find_by(person_id: person_details['person_id'])
    if person_id_exist
      puts '==================================================================='
      puts "Skipped assigning SID for person  with ID #{person_details['person_id']}"
      puts 'Reason: Person id already exist  for the above ID  in de_identifier'
      puts '==================================================================='
      puts ''
    else
    ## TODO: Write code to handle existing person_id
    npid = person_details['person_id']
    sid = create_sid

    DeIdentifiedIdentifier.create(identifier: sid, person_id: npid, voided: person_details['voided'], voided_by: person_details['voided_by'],
                                  voided_date: person_details['date_voided'], void_reason: person_details['void_reason'],
                                  app_date_created: person_details['app_date_created'], app_date_updated: person_details['app_date_updated'])

    puts "Successfully populated De_Identified identifier details with record for person #{person_details['person_id']}"
    end
  end
end

def create_sid
  sid = generate_id
  encode(sid)
end

def generate_id
  @lcg = if @lcg
           (1_664_525 * @lcg + 1_013_904_223) % (2**32)
         else
           rand(2**32) # Random seed
         end
end

def encode(n)
  @ENCODE_CHARS = [*'a'..'z', *'A'..'Z']
  6.times.map do |_i|
    n, mod = n.divmod(@ENCODE_CHARS.size)
    @ENCODE_CHARS[mod]
  end.join
end

def methods_init
  if File.file?('/tmp/ids_builder.lock')
    puts "Another Instance running"
    exit
  else
    FileUtils.touch '/tmp/ids_builder.lock'
  end

  populate_people
  populate_person_names
  populate_contact_details
  populate_person_address
  update_person_type
  populate_encounters
  populate_diagnosis
  populate_pregnant_status
  populate_breastfeeding_status
  populate_vitals
  populate_patient_history
  populate_symptoms
  populate_side_effects
  populate_presenting_complaints
  populate_tb_statuses
  populate_outcomes
  populate_family_planning
  populate_appointment
  populate_prescription
  populate_lab_orders
  populate_occupation
  populate_dispensation
  populate_adherence
  populate_relationships
  populate_hiv_staging_info
  populate_precription_has_regimen
  populate_lab_test_results
  initiate_de_duplication
  populate_de_identifier

   FileUtils.rm '/tmp/ids_builder.lock' if File.file?('/tmp/ids_builder.lock')
end

methods_init
  