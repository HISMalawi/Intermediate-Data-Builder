# frozen_string_literal: true

require 'yaml'
require_relative 'ids_commons'
require_relative 'ids_diagnosis'
require_relative 'ids_patient_history'
require_relative 'rds_end'
require_relative 'ids_person_address'
require_relative 'ids_vitals'
require_relative 'ids_patient_symptoms'
require_relative 'ids_presenting_complaints'
require_relative 'ids_side_effects'
require_relative 'ids_tb_statuses'
require_relative 'ids_family_planning'

@rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']
File.open("#{Rails.root}/log/last_update.yml", 'w') unless File.exist?("#{Rails.root}/log/last_update.yml") # Create a tracking file if it does not exist
@last_updated = YAML.load_file("#{Rails.root}/log/last_update.yml")
@batch_size = 50_000
@threshold = 85

def get_all_rds_people
  last_updated = get_last_updated('Person')

  rds_people = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person where date_created >= '#{last_updated}' ORDER BY date_created;
QUERY
end

def get_rds_person_name(person_id)
  @last_updated['PersonName'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['PersonName']
  person_name = []
  rds_person_name = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_name where person_id = #{person_id}
	AND (created_at >= '#{last_updated}');
QUERY
  rds_person_name.each { |name| person_name << name }
end

def get_rds_person_addresses(person_id)
  @last_updated['PersonAddress'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['PersonAddress']
  person_address = []
  rds_address = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_address where person_id = #{person_id}
	AND (date_created >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

QUERY

  rds_address.each { |address| person_address << address }
end

def get_rds_person_attributes
  last_updated = get_last_updated('PersonAttribute')
  person_attribute = []
  rds_attribute = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_attribute WHERE person_attribute_type_id IN (12,14,15)
	AND (date_created >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

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
	SELECT * FROM #{@rds_db}.users where date_created >= '#{last_updated}'
	OR date_changed >= '#{last_updated}'
	OR date_voided  >= '#{last_updated}'
  ORDER BY date_created, date_changed, date_voided;

QUERY
end

def find_duplicates(subject, subject_person_id)
  duplicates = ActiveRecord::Base.connection.select_all <<QUERY
			SELECT person_id, ROUND(CAST((((length("#{subject}") - levenshtein(person_de_duplicator,"#{subject}",2))/ length("#{subject}")) * 100) AS DECIMAL),2)
 as score FROM de_duplicators WHERE person_id != #{subject_person_id};
QUERY
end

def process_duplicates(duplicates, duplicate_id)
  duplicates.each do |duplicate|
    if duplicate['score'].to_f >= @threshold
      # save to duplicate_statuses
      PotentialDuplicate.create(person_id_a: duplicate_id, person_id_b: duplicate['person_id'], score: duplicate['score'].to_f)
    end
  end
end

def check_for_duplicate(demographics)
  # find matching text in de_duplicator table
  subject = ''
  begin
    subject << demographics[:person_names][0]['given_name']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_names][0]['family_name']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person]['gender']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person]['birthdate'].strftime('%Y-%m-%d').gsub('-', '')
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['address2']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['county_district']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['neighborhood_cell']
  rescue StandardError
    nil
  end

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
  get_all_rds_people.each do |person|
    person['birthdate'].blank? ? dob = "'1900-01-01'" : dob = "'#{person['birthdate'].to_date}'"

    person['death_date'].blank? ? dod = 'NULL' : dod = "'#{person['death_date'].to_date}'"

    person['date_voided'].blank? ? voided_date = 'NULL' : voided_date = "'#{person['date_voided'].strftime('%Y-%m-%d %H:%M:%S')}'"

    person['date_created'].blank? ? app_created_at = 'NULL' : app_created_at = "'#{person['date_created'].strftime('%Y-%m-%d %H:%M:%S')}'"

    person['date_changed'].blank? ? app_updated_at = 'NULL' : app_updated_at = "'#{person['date_changed'].strftime('%Y-%m-%d %H:%M:%S')}'"

    gender = person['gender'] == 'M' ? 1 : 0

    puts "processing person_id #{person['person_id']}"

    person_exits = Person.find_by(person_id: person['person_id'])

    if person_exits.blank?
      Person.create(person_id: person['person_id'].to_i, birthdate: dob, birthdate_est: person['birthdate_estimated'].to_i,
                    gender: gender.to_i, death_date: dod, cause_of_death: person['cause_of_death'], dead: person['dead'].to_i,
                    voided: person['voided'].to_i, voided_by: person['voided_by'].to_i, voided_date: voided_date,
                    void_reason: person['void_reason'].to_i, app_date_created: app_created_at, app_date_updated: app_updated_at)
    else
      person_exits.update(birthdate: dob, birthdate_est: person['birthdate_estimated'].to_i,
                          gender: gender.to_i, death_date: dod, cause_of_death: person['cause_of_death'], dead: person['dead'].to_i,
                          voided: person['voided'].to_i, voided_by: person['voided_by'].to_i, voided_date: voided_date,
                          void_reason: person['void_reason'].to_i, app_date_created: app_created_at, app_date_updated: app_updated_at)

      puts 'Updating'
    end
    update_last_update('Person', person['date_created'])
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
  rds_people = get_all_rds_people
  rds_people.each do |person|
    demographics = {}
    demographics = { "person": person }
    demographics.update("person_names": get_rds_person_name(person['person_id']))
    demographics.update("person_address": get_rds_person_addresses(person['person_id']))

    check_for_duplicate(demographics)
  end
end

def populate_person_names
  last_updated = get_last_updated('PersonNames')
  person_names = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.person_name WHERE date_created >= '#{last_updated}' OR date_changed >= '#{last_updated}'
  OR date_voided = '#{last_updated}';
SQL

  person_names.each do |person_name|
    puts "Updating Person Name for person_id: #{person_name['person_id']}"
    person_name_exist = PersonName.find_by(person_name_id: person_name['person_name_id'])

    if person_name_exist.blank?
      PersonName.create(person_name_id: person_name['person_name_id'], person_id: person_name['person_id'],
                        given_name: person_name['given_name'], family_name: person_name['family_name'],
                        middle_name: person_name['middle_name'], maiden_name: person_name['maiden_name'],
                        creator: person_name['creator'], voided: person_name['voided'], voided_by: person_name['voided_by'],
                        void_reason: person_name['void_reason'], app_date_created: person_name['date_created'],
                        app_date_updated: person_name['date_updated'])
    else
      person_name_exist.update(person_name_id: person_name['person_name_id'], person_id: person_name['person_id'],
                               given_name: person_name['given_name'], family_name: person_name['family_name'],
                               middle_name: person_name['middle_name'], maiden_name: person_name['maiden_name'],
                               creator: person_name['creator'], voided: person_name['voided'], voided_by: person_name['voided_by'],
                               void_reason: person_name['void_reason'], app_date_created: person_name['date_created'],
                               app_date_updated: person_name['date_updated'])
    end
    update_last_update('PersonName', person_name['date_created'])
  end
end

def populate_contact_details
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
    current_update_date = {}
    current_update_date['PersonAttribute'] = person_attribute['date_created'].strftime('%Y-%m-%d %H:%M:%S')

    File.open('log/last_update.yml', 'w') do |file|
      file.write current_update_date.to_yaml
    end
  end
end

def populate_encounters
  last_updated = get_last_updated('Encounter')
  encounters = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.encounter WHERE  (date_created >= '#{last_updated}');
SQL

  encounters.each do |rds_encounter|
    puts "processing person_id #{rds_encounter['patient_id']}"
    rds_prog_id =  rds_encounter['program_id']
    program_name = ActiveRecord::Base.connection.select_all <<SQL
    SELECT name FROM #{@rds_db}.program  WHERE program_id = #{rds_prog_id}  limit 1
SQL
    rds_encounter_type_id = rds_encounter['encounter_type']
    rds_encounter_type = ActiveRecord::Base.connection.select_all <<SQL
    SELECT name FROM #{@rds_db}.encounter_type WHERE encounter_type_id = #{rds_encounter_type_id} limit 1
SQL
    ids_encounter_type_name = rds_encounter_type.first
    ids_prog_name = program_name.first
    master_definition_prog_id = MasterDefinition.find_by(definition: ids_prog_name['name'])
    master_definition_encounter_id = MasterDefinition.find_by(definition: ids_encounter_type_name['name'])

    if Encounter.find_by(person_id: rds_encounter).blank?
      encounter = Encounter.new
      encounter.encounter_type_id = master_definition_encounter_id['master_definition_id']
      encounter.program_id        = master_definition_prog_id['master_definition_id']
      encounter.person_id        = rds_encounter['patient_id']
      encounter.visit_date       = rds_encounter['encounter_datetime']
      encounter.voided           = rds_encounter['voided']
      encounter.voided_by        = rds_encounter['voided_by']
      encounter.voided_date      = rds_encounter['date_voided']
      encounter.void_reason      = rds_encounter['void_reason']
      encounter.app_date_created = rds_encounter['date_created']
      encounter.app_date_updated = rds_encounter['date_changed']
      encounter.save

      puts "Successfully populated encounter with record for person #{rds_encounter['patient_id']}"
    else
      encounter = Encounter.where(person_id: rds_encounter['patient_id'])
      encounter.update(encounter_type_id: rds_encounter[''])
      encounter.update(program_id: master_definition_prog_id['master_definition_id'])
      encounter.update(person_id: rds_encounter['patient_id'])
      encounter.update(visit_date: rds_encounter['encounter_datetime'])
      encounter.update(voided: rds_encounter['voided'])
      encounter.update(voided_by: rds_encounter['voided_by'])
      encounter.update(voided_date: rds_encounter['date_voided'])
      encounter.update(void_reason: rds_encounter['void_reason'])
      encounter.update(created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))
      encounter.update(updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated encounter details with record for person #{rds_encounter['patient_id']}"
    end
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

  users = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.users WHERE date_created >= '#{last_updated}'
  OR date_changed >= '#{last_updated}' OR date_retired >= '#{last_updated}';
SQL

  person_type_id = 4 # person type id for user
  (users || []).each do |user|
    person_has_type(person_type_id, user)
    update_last_update('User', user['date_created'])
  end

  # Updating Guardians in person type table
  last_updated = get_last_updated('Relationship')

  guardians = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.relationship WHERE date_created >= '#{last_updated}'
  AND relationship = 6;
SQL

  person_type_id = 5 # person type id for guardian
  (guardians || []).each do |guardian|
    person_has_type(person_type_id, guardian)
    update_last_update('Relationship', guardian['date_created'])
  end

  # Updating Guardians in person type table
  last_updated = get_last_updated('Patient')

  patients = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.patient WHERE date_created >= '#{last_updated}'
  OR date_changed >= '#{last_updated}' OR date_voided >= '#{last_updated}';
SQL

  person_type_id = 1 # person type id for patient
  (patients || []).each do |patient|
    person_has_type(person_type_id, patient)
    update_last_update('Patient', patient['date_created'])
  end

  # Updating Provider in person type table
  last_updated = get_last_updated('Patient')

  providers = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.users WHERE date_created >= '#{last_updated}'
  OR date_changed >= '#{last_updated}' OR date_retired >= '#{last_updated}';
SQL

  person_type_id = 2 # person type id for provider
  (providers || []).each do |provider|
    person_has_type(person_type_id, provider)
    update_last_update('Provider', provider['date_created'])
  end
end

def get_rds_diagnosis
  last_updated = get_last_updated('Diagnosis')

  ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.obs ob
  INNER JOIN #{@rds_db}.encounter en
  ON ob.encounter_id = en.encounter_id
  WHERE ob.concept_id IN (6542,6543)
	AND (ob.date_created >= '#{last_updated}'
	OR ob.date_voided  >=  '#{last_updated}');

QUERY
end

def populate_diagnosis
  primary_diagnosis = 6542
  secondary_diagnosis = 6543

  (get_rds_diagnosis || []).each do |diag|
    rds_diagnosis_person(diag, primary_diagnosis, secondary_diagnosis)
  end
end

def get_district_id(district)
  Location.find_by(name: district)['location_id'].to_i
end

def get_rds_vitals
  last_updated = get_last_updated('Vital')

  ActiveRecord::Base.connection.select_all <<~QUERY
    SELECT * FROM bht_rds_development.obs ob
    INNER JOIN bht_rds_development.encounter en
    on ob.encounter_id = en.encounter_id
    INNER JOIN bht_rds_development.encounter_type et
    ON en.encounter_type = et.encounter_type_id
    INNER JOIN bht_rds_development.concept_name cn
    ON cn.concept_id = ob.concept_id
    WHERE et.encounter_type_id = 6
    AND ob.concept_id IN (5085,5086,5087,5088,5089,5090,5092)
    AND (ob.date_created >= '#{last_updated}'
    OR ob.date_voided  >=  '#{last_updated}');

  QUERY
end

def populate_vitals
  (get_rds_vitals || []).each(&method(:vital_value_coded))
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

def get_master_def_id(openmrs_metadata_id)
  MasterDefinition.find_by_openmrs_metadata_id(openmrs_metadata_id).master_definition_id
rescue StandardError
  nil
end

def populate_pregnant_status
  last_updated = get_last_updated('PregnantStatus')

  pregnant_status = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.obs WHERE updated_at >= '#{last_updated}' and concept_id in (1755,6131) order by updated_at;
SQL

  (pregnant_status || []).each do |pregnant|
    puts "Updating Pregnant Status for person_id: #{pregnant['person_id']}"
    pregnant_status_exist = PregnantStatus.find_by(concept_id: pregnant['concept_id'],
                                                   encounter_id: pregnant['encounter_id'])

    # TODO
    # get_master_def_id() # get_master_def_id('Pregnant?')
    value_coded = MasterDefinition.find_by_definition('Pregnant?')['master_definition_id']
    if pregnant_status_exist.blank?
      PregnantStatus.create(concept_id: pregnant['concept_id'], encounter_id: pregnant['encounter_id'],
                            value_coded: value_coded, voided: pregnant['voided'], voided_by: pregnant['voided_by'],
                            voided_date: pregnant['voided_date'], void_reason: pregnant['void_reason'], app_date_created: pregnant['date_created'],
                            app_date_updated: pregnant['date_updated'])
    else
      pregnant_status_exist.update(concept_id: pregnant['concept_id'], encounter_id: pregnant['encounter_id'],
                                   value_coded: value_coded, voided: pregnant['voided'],
                                   voided_by: pregnant['voided_by'], voided_date: pregnant['voided_date'],
                                   app_date_created: pregnant['date_created'], app_date_updated: pregnant_status['date_updated'])
    end
    update_last_update('PregnantStatus', pregnant['updated_at'])
  end
end

def populate_breastfeeding_status
  last_updated = get_last_updated('BreastfeedingStatus')

  breastfeeding_statuses = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.obs WHERE updated_at >= '#{last_updated}'
  AND concept_id IN (SELECT concept_id FROM #{@rds_db}.concept_name WHERE name LIKE '%breastfeeding%')
  ORDER BY updated_at;
SQL

  (breastfeeding_statuses || []).each do |breastfeeding_status|
    puts "Updating Breastfeeding Status for person_id: #{breastfeeding_status['person_id']}"
    breastfeeding_status_exist = BreastfeedingStatus.find_by(concept_id: breastfeeding_status['concept_id'],
                                                             encounter_id: breastfeeding_status['encounter_id'])

    # TODO
    # get_master_def_id() # get_master_def_id('Pregnant?')
    value_coded = get_master_def_id(breastfeeding_status['concept_id'])
    if breastfeeding_status_exist.blank?
      PregnantStatus.create(concept_id: breastfeeding_status['concept_id'], encounter_id: breastfeeding_status['encounter_id'],
                            value_coded: value_coded, voided: breastfeeding_status['voided'], voided_by: breastfeeding_status['voided_by'],
                            voided_date: breastfeeding_status['voided_date'], void_reason: breastfeeding_status['void_reason'], app_date_created: breastfeeding_status['date_created'],
                            app_date_updated: breastfeeding_status['date_updated'])
    else
      breastfeeding_status_exist.update(concept_id: breastfeeding_status['concept_id'], encounter_id: breastfeeding_status['encounter_id'],
                                        value_coded: value_coded, voided: breastfeeding_status['voided'],
                                        voided_by: breastfeeding_status['voided_by'], voided_date: breastfeeding_status['voided_date'],
                                        app_date_created: breastfeeding_status['date_created'], app_date_updated: breastfeeding_status['date_updated'])
    end
    update_last_update('BreastfeedingStatus', breastfeeding_status['updated_at'])
  end
end

def populate_person_address
  last_updated = get_last_updated('PersonAddress')

  person_addresses = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.person_address WHERE date_created >= '#{last_updated}' order by date_created;
SQL
  person_addresses.each(&method(:grouped_address))
end

def populate_patient_history
  last_updated = get_last_updated('PatientHistory')

  patient_histories = ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.obs ob
                      INNER JOIN #{@rds_db}.encounter en
                                 ON ob.encounter_id = en.encounter_id
                      INNER JOIN #{@rds_db}.encounter_type et
                                 ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type WHERE name like '%history%')
    AND ob.updated_at >= '#{last_updated}';
  SQL

  (patient_histories || []).each(&method(:ids_patient_history))
end

def populate_symptoms
  last_updated = get_last_updated('Symptoms')

  patient_symptoms = ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.obs ob
                      INNER JOIN #{@rds_db}.encounter en
                                 ON ob.encounter_id = en.encounter_id
                      INNER JOIN #{@rds_db}.encounter_type et
                                 ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type WHERE name like '%symptoms')
    AND ob.updated_at >= '#{last_updated}';
  SQL

  (patient_symptoms || []).each(&method(:ids_patient_symptoms))
end

def populate_side_effects
  last_updated = get_last_updated('SideEffects')

  patient_side_effects = ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.obs ob
                      INNER JOIN #{@rds_db}.encounter en
                                 ON ob.encounter_id = en.encounter_id
                      INNER JOIN #{@rds_db}.encounter_type et
                                 ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type where name like '%hiv clinic consultation%')
    AND ob.updated_at >= '#{last_updated}';
  SQL

  (patient_side_effects || []).each(&method(:ids_side_effects))
end

def populate_presenting_complaints
  last_updated = get_last_updated('PresentingComplaints')

  presenting_complaints = ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.obs ob
                      INNER JOIN #{@rds_db}.encounter en
                                 ON ob.encounter_id = en.encounter_id
                      INNER JOIN #{@rds_db}.encounter_type et
                                 ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id = 122
    AND ob.updated_at >= '#{last_updated}';
  SQL

  (presenting_complaints || []).each(&method(:ids_presenting_complaints))
end

def populate_tb_statuses
  last_updated = get_last_updated('TbStatus')

  tb_statuses = ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.obs ob
                      INNER JOIN #{@rds_db}.encounter en
                                 ON ob.encounter_id = en.encounter_id
                      INNER JOIN #{@rds_db}.encounter_type et
                                 ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id = 7459
    AND ob.updated_at >= '#{last_updated}';
  SQL

  (tb_statuses || []).each(&method(:ids_tb_statuses))
end

def populate_family_planning
  last_updated = get_last_updated('FamilyPlanning')

  family_planning_methods = ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.obs ob
                      INNER JOIN #{@rds_db}.encounter en
                                 ON ob.encounter_id = en.encounter_id
                      INNER JOIN #{@rds_db}.encounter_type et
                                 ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id = 7459
    AND ob.updated_at >= '#{last_updated}';
  SQL

  (family_planning_methods || []).each(&method(:ids_family_planning))
end

def populate_outcomes
  last_updated = get_last_updated('Outcome')

  outcomes = ActiveRecord::Base.connection.select_all <<SQL
    SELECT * FROM #{@rds_db}.patient_program pp
    INNER JOIN #{@rds_db}.patient_state ps ON  pp.patient_program_id = ps.patient_program_id
    INNER JOIN  #{@rds_db}.program_workflow pw ON pp.program_id = pw.program_id
   INNER JOIN #{@rds_db}.program_workflow_state pws ON pw.program_workflow_id = pws.program_workflow_id
   WHERE  (pp.date_created >= '#{last_updated}' );
SQL

  (outcomes || []).each do |rds_outcomes|
    puts "processing person_id #{rds_outcomes['patient_id']}"

    if Outcome.find_by(person_id: rds_outcomes['patient_id']).blank?
      outcome = Outcome.new
      outcome.person_id        = rds_outcomes['patient_id']
      outcome.concept_id       = rds_outcomes['concept_id']
      outcome.outcome_reason   = begin
                                   MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['concept_id']).master_definition_id
                                 rescue StandardError
                                   nil
                                 end
      outcome.outcome_source   = begin
                                   MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['program_id']).master_definition_id
                                 rescue StandardError
                                   nil
                                 end
      outcome.voided           = rds_outcomes['voided']
      outcome.voided_by        = rds_outcomes['voided_by']
      outcome.voided_date      = rds_outcomes['date_voided']
      outcome.void_reason      = rds_outcomes['void_reason']
      outcome.app_date_created = rds_outcomes['date_created']
      outcome.app_date_updated = rds_outcomes['date_changed']
      outcome.save

      puts "Successfully populated Outcome with record for person #{rds_outcomes['patient_id']}"
    else
      outcome = Outcome.where(person_id: rds_outcomes['patient_id'])
      outcome.update(person_id: rds_outcomes['patient_id'])
      outcome.update(concept_id: rds_outcomes['concept_id'])
      begin
        outcome.update(outcome_reason: MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['concept_id']).master_definition_id)
      rescue StandardError
        nil
      end
      begin
        outcome.update(outcome_source: MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['program_id']).master_definition_id)
      rescue StandardError
        nil
      end
      outcome.update(voided: rds_outcomes['voided'])
      outcome.update(voided_by: rds_outcomes['voided_by'])
      outcome.update(voided_date: rds_outcomes['date_voided'])
      outcome.update(void_reason: rds_outcomes['void_reason'])
      outcome.update(created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))
      outcome.update(updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated outcome details with record for person #{rds_outcomes['patient_id']}"
    end
  end
end

def populate_occupation
  last_updated = get_last_updated('Occupation')
  occupations = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM #{@rds_db}.person_attribute WHERE  person_attribute_type_id = 13
  AND (date_created >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');
SQL
  occupations.each do |rds_occupation|
    puts "processing person_id #{rds_occupation['person_id']}"

    if Occupation.find_by(person_id: rds_occupation).blank?
      person_occupation = Occupation.new
      person_occupation.person_id    = rds_occupation['person_id']
      person_occupation.occupation   = rds_occupation['value']
      person_occupation.creator      = rds_occupation['creator']
      person_occupation.voided       = rds_occupation['voided']
      person_occupation.voided_by    = rds_occupation['voided_by']
      person_occupation.voided_date  = rds_occupation['date_voided']
      person_occupation.void_reason  = rds_occupation['void_reason']
      person_occupation.app_date_created = rds_occupation['date_created']
      person_occupation.app_date_updated = rds_occupation['date_changed']
      person_occupation.save

      puts "Successfully populated occupation with record for person #{rds_occupation['person_id']}"
    else
      person_occupation = Occupation.where(person_id: rds_occupation['person_id'])
      person_occupation.update(eperson_id: rds_occupation['person_id'])
      person_occupation.update(occupation: rds_occupation['value'])
      person_occupation.update(person_id: rds_occupation['creator'])
      person_occupation.update(voided: rds_occupation['voided'])
      person_occupation.update(voided_by: rds_occupation['voided_by'])
      person_occupation.update(voided_date: rds_occupation['date_voided'])
      person_occupation.update(void_reason: rds_occupation['void_reason'])
      person_occupation.update(created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))
      person_occupation.update(updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated occupation details with record for person #{rds_occupation['person_id']}"

    end
  end
end

def populate_appointment
  last_updated = get_last_updated('Appointment')

  appointments = ActiveRecord::Base.connection.select_all <<SQL
    SELECT ob.person_id,ob.encounter_id, value_datetime,ob.voided,ob.voided_by,ob.creator,ob.date_voided,ob.void_reason,en.date_created ,en.date_changed
    FROM #{@rds_db}.encounter en
    INNER JOIN #{@rds_db}.obs ob on en.encounter_id = ob.encounter_id
    WHERE ob.concept_id = 5096
    AND (en.date_created >= '#{last_updated}' );
SQL

  (appointments || []).each do |rds_appointment|
    puts "processing person_id #{rds_appointment['person_id']}"

    if Appointment.find_by(encounter_id: rds_appointment['encounter_id']).blank?
      appointment = Appointment.new
      appointment.encounter_id     = rds_appointment['encounter_id']
      appointment.appointment_date = rds_appointment['value_datetime']
      appointment.voided           = rds_appointment['voided']
      appointment.voided_by        = rds_appointment['voided_by']
      appointment.creator          = rds_appointment['creator']
      appointment.voided_date      = rds_appointment['date_voided']
      appointment.void_reason      = rds_appointment['void_reason']
      appointment.app_date_created = rds_appointment['date_created']
      appointment.app_date_updated = rds_appointment['date_changed']
      appointment.save

      puts "Successfully populated appointment with record for person #{rds_appointment['person_id']}"
    else
      appointment = Appointment.where(encounter_id: rds_appointment['encounter_id'])
      appointment.update(encounter_id: rds_appointment['encounter_id'])
      appointment.update(appointment_date: rds_appointment['value_datetime'])
      appointment.update(voided: rds_appointment['voided'])
      appointment.update(voided_by: rds_appointment['voided_by'])
      appointment.update(creator: rds_appointment['creator'])
      appointment.update(voided_date: rds_appointment['date_voided'])
      appointment.update(void_reason: rds_appointment['void_reason'])
      appointment.update(created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))
      appointment.update(updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated appointment details with record for person #{rds_appointment['person_id']}"
    end
  end
end

def populate_prescription
  last_updated = get_last_updated('MedicationPrescription')

  prescription = ActiveRecord::Base.connection.select_all <<SQL
    SELECT o.encounter_id, o.start_date,o.instructions,o.order_id,o.patient_id,obs.concept_id,drug_id,o.date_created,o.voided,o.voided_by,o.void_reason,obs.date_stopped
    FROM #{@rds_db}.encounter en
    INNER JOIN #{@rds_db}.orders o on en.encounter_id = o.encounter_id  
    INNER JOIN #{@rds_db}.obs  on en.encounter_id = obs.encounter_id
    INNER JOIN #{@rds_db}.drug on obs.concept_id = drug.concept_id
    where (en.date_created >= '#{last_updated}' );
SQL
  (prescription || []).each do |rds_prescription|

    puts "processing person_id #{rds_prescription['patient_id']}"

    if MedicationPrescription.find_by(encounter_id: rds_prescription['encounter_id']).blank?
      medication_prescription = MedicationPrescription.new
      medication_prescription.drug_id          = rds_prescription['drug_id']
      medication_prescription.encounter_id     = rds_prescription['encounter_id']
      medication_prescription.start_date       = rds_prescription['start_date']
      medication_prescription.end_name         = rds_prescription['date_stopped']
      medication_prescription.instructions     = rds_prescription['instructions']
      medication_prescription.voided           = rds_prescription['voided']
      medication_prescription.voided_by        = rds_prescription['voided_by']
      medication_prescription.voided_date      = rds_prescription['date_voided']
      medication_prescription.void_reason      = rds_prescription['void_reason']
      medication_prescription.app_date_created = rds_prescription['date_created']
      medication_prescription.app_date_updated = rds_prescription['date_changed']
      medication_prescription.save

      puts "Successfully populated medication prescription details with record for person #{rds_prescription['patient_id']}"
    else
      medication_prescription = MedicationPrescription.where(encounter_id: rds_prescription['encounter_id'])
      medication_prescription.update(drug_id:      rds_prescription['drug_id'])
      medication_prescription.update(encounter_id: rds_prescription['encounter_id'])
      medication_prescription.update(start_date:   rds_prescription['start_date'])
      medication_prescription.update(end_name:     rds_prescription['date_stopped'])
      medication_prescription.update(instructions: rds_prescription['instructions'])
      medication_prescription.update(voided:       rds_prescription['voided'])
      medication_prescription.update(voided_by:     rds_prescription['voided_by'])
      medication_prescription.update(voided_date:   rds_prescription['date_voided'])
      medication_prescription.update(void_reason:   rds_prescription['void_reason'])
      medication_prescription.update(created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))
      medication_prescription.update(updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated medication prescription details with record for person #{rds_prescription['patient_id']}"

    end
  end
end

def methods_init
  populate_people
  populate_person_names
  populate_contact_details
  populate_person_address
  update_person_type

  # initiate_de_duplication
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


end

methods_init
