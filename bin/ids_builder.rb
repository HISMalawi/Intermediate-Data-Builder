# frozen_string_literal: true

require 'yaml'
require_relative 'ids_commons'
require_relative 'ids_person_name'
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
require_relative 'ids_encounter'
require_relative 'ids_contacts'

@rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']
File.open("#{Rails.root}/log/last_update.yml", 'w') unless File.exist?("#{Rails.root}/log/last_update.yml") # Create a tracking file if it does not exist
@last_updated = YAML.load_file("#{Rails.root}/log/last_update.yml")
@batch_size = 50_000
@threshold = 85

def get_all_rds_people
  last_updated = get_last_updated('Person')

  rds_people = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person where updated_at >= '#{last_updated}' ORDER BY updated_at;
QUERY
  rds_people
end

def get_rds_person_name(person_id)
  last_updated = get_last_updated('PersonName')
  person_name = []
  rds_person_name = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_name where person_id = #{person_id}
	AND (created_at >= '#{last_updated}');
QUERY
  rds_person_name.each { |name| person_name << name }
end

def get_rds_person_addresses(person_id)
  last_updated = get_last_updated('PersonAddress')
  person_address = []
  rds_address = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_address where person_id = #{person_id}
	AND (updated_at >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

QUERY

  rds_address.each { |address| person_address << address }
end

def get_rds_person_attributes
  last_updated = get_last_updated('PersonAttribute')
  person_attribute = []
  rds_attribute = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_attribute WHERE person_attribute_type_id IN (12,14,15)
	AND (updated_at >= '#{last_updated}');

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
  subject  += demographics[:person_names][0]['given_name'] rescue  nil
  subject << demographics[:person_names][0]['family_name'] rescue  nil
  subject <<  demographics[:person]['gender'] rescue  nil
  subject <<  demographics[:person]['birthdate'].strftime('%Y-%m-%d').gsub('-', '') rescue  nil
  subject <<  demographics[:person_address][0]['address2'] rescue  nil
  subject <<  demographics[:person_address][0]['county_district'] rescue  nil
  subject <<  demographics[:person_address][0]['neighborhood_cell'] rescue  nil
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
  last_updated = get_last_updated('Person')

  query = "SELECT * FROM #{@rds_db}.person WHERE updated_at >= '#{last_updated}'
           ORDER BY updated_at "

  populate_data(query, 'ids_people', 'people','Person', 
    Person.column_names[0..-3].join(','))
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

  query = "SELECT * FROM #{@rds_db}.person_name WHERE
           updated_at >= '#{last_updated}' ORDER BY updated_at "

  populate_data(query, 'ids_person_name', 'person_names','PersonName', 
    PersonName.column_names[0..-3].join(','))
end

def populate_contact_details
  last_updated = get_last_updated('PersonAttribute')

  query = "SELECT person_id,
           MAX((CASE WHEN person_attribute_type_id = 12 THEN value ELSE NULL END)) AS cell_phone_number,
           MAX((CASE WHEN person_attribute_type_id = 14 THEN value ELSE NULL END)) AS home_phone_number,
           MAX((CASE WHEN person_attribute_type_id = 15 THEN value ELSE NULL END)) AS work_phone_number,
           MAX(date_created) date_created,
           MAX(date_changed) date_changed,
           updated_at
           FROM 
           #{@rds_db}.person_attribute
           group by person_id 
           ORDER BY updated_at "

 populate_data(query, 'ids_contact_details', 'contact_details', 'ContactDetails',
    ContactDetail.column_names[0..-3].join(','))   

end

def populate_encounters
  last_updated = get_last_updated('Encounter')

  query = "SELECT * FROM #{@rds_db}.encounter WHERE
           updated_at >= '#{last_updated}' ORDER BY updated_at "

   populate_data(query, 'process_encounter', 'encounters','Encounter', 
    Encounter.column_names[0..-3].join(','))
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
  last_updated = get_last_updated('User')
  # Updating users type in person_type table
   query = "SELECT * FROM #{@rds_db}.users WHERE 
            updated_at >= '#{last_updated}' ORDER BY updated_at "

   populate_data(query, 'person_has_type', 'person_has_types','User', 
    PersonHasType.column_names[0..-3].join(','))

  last_updated = get_last_updated('Guardian')
  # Updating Guardians in person type table
   query = "SELECT * FROM #{@rds_db}.relationship WHERE
            updated_at >= '#{last_updated}' ORDER BY updated_at "

   populate_data(query, 'person_has_type', 'person_has_types','Guardian', 
    PersonHasType.column_names[0..-3].join(','))

  last_updated = get_last_updated('Patient')
  # Updating Patients in person type table
  query = "SELECT * FROM #{@rds_db}.patient WHERE
           updated_at >= '#{last_updated}' ORDER BY updated_at "

   populate_data(query, 'person_has_type', 'person_has_types','Patient', 
    PersonHasType.column_names[0..-3].join(','))

  last_updated = get_last_updated('Provider')
  # Updating Provider in person type table
  query = "SELECT * FROM #{@rds_db}.users WHERE
           updated_at >= '#{last_updated}' ORDER BY updated_at "

   populate_data(query, 'person_has_type', 'person_has_types','Provider', 
    PersonHasType.column_names[0..-3].join(','))

end

def get_rds_diagnosis
  last_updated = get_last_updated('Diagnosis')

  ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.obs ob
  INNER JOIN #{@rds_db}.encounter en
  ON ob.encounter_id = en.encounter_id
  WHERE ob.concept_id IN (6542,6543)
	AND (ob.updated_at >= '#{last_updated}'
	OR ob.date_voided  >=  '#{last_updated}');

QUERY
end

def populate_diagnosis
last_updated = get_last_updated('Diagnosis')

  query = "SELECT ob.*,
           MAX(CASE WHEN ob.concept_id = 6542 THEN value_coded ELSE NULL END) AS primary_diag,
           MAX(CASE WHEN ob.concept_id = 6543 THEN value_coded ELSE NULL END) AS sec_diag
           FROM #{@rds_db}.obs ob
           INNER JOIN #{@rds_db}.encounter en
           ON ob.encounter_id = en.encounter_id
           WHERE ob.concept_id IN (6542,6543)
           GROUP BY encounter_id
           ORDER BY updated_at "

  populate_data(query, 'ids_diagnosis_person', 'diagnosis', 'Diagnosis', 
    Diagnosis.column_names[0..-3].join(','))
end

def get_district_id(district)
  Location.find_by(name: district)['location_id'].to_i
end

def populate_vitals
  last_updated = get_last_updated('Vital')
  
  query = "SELECT * FROM #{@rds_db}.obs ob
    INNER JOIN #{@rds_db}.encounter en
    on ob.encounter_id = en.encounter_id
    INNER JOIN #{@rds_db}.encounter_type et
    ON en.encounter_type = et.encounter_type_id
    INNER JOIN #{@rds_db}.concept_name cn
    ON cn.concept_id = ob.concept_id
    WHERE et.encounter_type_id = 6
    AND ob.concept_id IN (5085,5086,5087,5088,5089,5090,5092)
    AND ob.updated_at >= '#{last_updated}' "

  populate_data(query, 'vital_value_coded', 'vitals', 'Vital', 
    Vital.column_names[0..-3].join(','))

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

  query = "SELECT * FROM #{@rds_db}.obs WHERE updated_at >= '#{last_updated}' 
           AND concept_id in (1755,6131) order by updated_at "
  
  populate_data(query, 'ids_pregnant_status', 'pregnant_statuses', 'PregnantStatus', 
    PregnantStatus.column_names[0..-3].join(','))
end

def populate_breastfeeding_status
  last_updated = get_last_updated('BreastfeedingStatus')

  query = "SELECT * FROM #{@rds_db}.obs WHERE updated_at >= '#{last_updated}'
           AND concept_id IN (SELECT concept_id FROM #{@rds_db}.concept_name 
           WHERE name LIKE '%breastfeeding%')
           ORDER BY updated_at "
  
  populate_data(query, 'ids_breastfeeding_status', 'breastfeeding_statuses', 'BreastfeedingStatus', 
    PregnantStatus.column_names[0..-3].join(','))
end

def populate_person_address
  last_updated = get_last_updated('PersonAddress')

  query = "SELECT * FROM #{@rds_db}.person_address WHERE
           updated_at >= '#{last_updated}' ORDER BY updated_at "

  populate_data(query, 'grouped_address', 'person_addresses','PersonAddress', 
    PersonAddress.column_names[0..-3].join(','))
end

def populate_patient_history
  last_updated = get_last_updated('PatientHistory')

  query = "SELECT * FROM #{@rds_db}.obs ob
    INNER JOIN #{@rds_db}.encounter en
    ON ob.encounter_id = en.encounter_id
    INNER JOIN #{@rds_db}.encounter_type et
    ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type WHERE name like '%history%')
    AND ob.updated_at >= '#{last_updated}'
    ORDER BY ob.updated_at "
  
  populate_data(query, 'ids_patient_history', 'patient_histories', 'PatientHistory',
    PatientHistory.column_names[0..-3].join(','))
end

def populate_symptoms
  last_updated = get_last_updated('Symptom')

  query = "SELECT * FROM #{@rds_db}.obs ob
    INNER JOIN #{@rds_db}.encounter en
    ON ob.encounter_id = en.encounter_id
    INNER JOIN #{@rds_db}.encounter_type et
    ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type WHERE name like '%symptoms')
    AND ob.updated_at >= '#{last_updated}'
    ORDER BY ob.updated_at "
  
  populate_data(query, 'ids_patient_symptoms', 'symptoms', 'Symptom',
    Symptom.column_names[0..-3].join(','))
end

def populate_side_effects
  last_updated = get_last_updated('SideEffects')

  query = "SELECT * FROM #{@rds_db}.obs ob
    INNER JOIN #{@rds_db}.encounter en
    ON ob.encounter_id = en.encounter_id
    INNER JOIN #{@rds_db}.encounter_type et
    ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type where name like '%hiv clinic consultation%')
    AND ob.updated_at >= '#{last_updated}'
    ORDER BY ob.updated_at "
  
  populate_data(query, 'ids_side_effects', 'side_effects', 'SideEffects',
    SideEffect.column_names[0..-3].join(','))
end

def populate_presenting_complaints
  last_updated = get_last_updated('PresentingComplaints')

  query = "SELECT * FROM #{@rds_db}.obs ob
    INNER JOIN #{@rds_db}.encounter en
    ON ob.encounter_id = en.encounter_id
    INNER JOIN #{@rds_db}.encounter_type et
    ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id = 122
    AND ob.updated_at >= '#{last_updated}'
    ORDER BY ob.updated_at "
  
  populate_data(query, 'ids_presenting_complaints', 'presenting_complaints', 'PresentingComplaints',
    PresentingComplaint.column_names[0..-3].join(','))
end

def populate_tb_statuses
  last_updated = get_last_updated('TbStatus')


  query = "SELECT * FROM #{@rds_db}.obs ob
    INNER JOIN #{@rds_db}.encounter en
    ON ob.encounter_id = en.encounter_id
    INNER JOIN #{@rds_db}.encounter_type et
    ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id = 7459
    AND ob.updated_at >= '#{last_updated}'
    ORDER BY ob.updated_at "
  
  populate_data(query, 'ids_tb_statuses', 'tb_statuses', 'TbStatus',
    PresentingComplaint.column_names[0..-3].join(','))
end

def populate_family_planning
  last_updated = get_last_updated('FamilyPlanning')

  query = "SELECT * FROM #{@rds_db}.obs ob
    INNER JOIN #{@rds_db}.encounter en
    ON ob.encounter_id = en.encounter_id
    INNER JOIN #{@rds_db}.encounter_type et
    ON en.encounter_type = et.encounter_type_id
    WHERE et.encounter_type_id = 7459
    AND ob.updated_at >= '#{last_updated}'
    ORDER BY ob.updated_at "
  
  populate_data(query, 'ids_family_planning', 'family_plannings', 'FamilyPlanning',
    FamilyPlanning.column_names[0..-3].join(','))
end

def populate_outcomes
  last_updated = get_last_updated('Outcome')

  outcomes = ActiveRecord::Base.connection.select_all <<SQL
    SELECT * FROM #{@rds_db}.patient_program pp
    INNER JOIN #{@rds_db}.patient_state ps ON  pp.patient_program_id = ps.patient_program_id
    INNER JOIN  #{@rds_db}.program_workflow pw ON pp.program_id = pw.program_id
   INNER JOIN #{@rds_db}.program_workflow_state pws ON pw.program_workflow_id = pws.program_workflow_id
   WHERE  (pp.updated_at >= '#{last_updated}' );
SQL

  (outcomes || []).each do |rds_outcomes|
    puts "processing person_id #{rds_outcomes['patient_id']}"

    if Outcome.find_by(person_id: rds_outcomes['patient_id']).blank?
      outcome = Outcome.new
      outcome.person_id = rds_outcomes['patient_id']
      outcome.concept_id = rds_outcomes['concept_id']
      outcome.outcome_reason = begin
        MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['concept_id']).master_definition_id
                               rescue StandardError
                                 nil
      end
      outcome.outcome_source = begin
        MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['program_id']).master_definition_id
                               rescue StandardError
                                 nil
      end
      outcome.voided = rds_outcomes['voided']
      outcome.voided_by = rds_outcomes['voided_by']
      outcome.voided_date = rds_outcomes['date_voided']
      outcome.void_reason = rds_outcomes['void_reason']
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
  AND updated_at >= '#{last_updated}'
SQL
  (occupations || []).each do |rds_occupation|
    puts "processing person_id #{rds_occupation['person_id']}"

    if Occupation.find_by(person_id: rds_occupation['person_id']).blank?
      person_occupation = Occupation.new
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
    else
      person_occupation = Occupation.where(person_id: rds_occupation['person_id'])
      person_occupation.update(occupation: rds_occupation['value'],
                               person_id: rds_occupation['creator'], voided: rds_occupation['voided'],
                               voided_by: rds_occupation['voided_by'], voided_date: rds_occupation['date_voided'],
                               void_reason: rds_occupation['void_reason'], created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'),
                               updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated occupation details with record for person #{rds_occupation['person_id']}"

    end
  end
end

# def populate_appointment
#   last_updated = get_last_updated('Appointment')

#   appointments = ActiveRecord::Base.connection.select_all <<SQL
#     SELECT ob.person_id,ob.encounter_id, value_datetime,ob.voided,ob.voided_by,ob.creator,ob.date_voided,ob.void_reason,en.date_created ,en.date_changed
#     FROM #{@rds_db}.encounter en
#     INNER JOIN #{@rds_db}.obs ob on en.encounter_id = ob.encounter_id
#     WHERE ob.concept_id = 5096
#     AND en.updated_at >= '#{last_updated}' );
# SQL

# end

# def ids_appointment(rds_appointment)
#     puts "processing person_id #{rds_appointment['person_id']}"

#     if Appointment.find_by(encounter_id: rds_appointment['encounter_id']).blank?
#       appointment = Appointment.new
#       appointment.encounter_id = rds_appointment['encounter_id']
#       appointment.appointment_date = rds_appointment['value_datetime']
#       appointment.voided = rds_appointment['voided']
#       appointment.voided_by = rds_appointment['voided_by']
#       appointment.creator = rds_appointment['creator']
#       appointment.voided_date = rds_appointment['date_voided']
#       appointment.void_reason = rds_appointment['void_reason']
#       appointment.app_date_created = rds_appointment['date_created']
#       appointment.app_date_updated = rds_appointment['date_changed']
#       appointment.save

#       puts "Successfully populated appointment with record for person #{rds_appointment['person_id']}"
#     else
#       appointment = Appointment.where(encounter_id: rds_appointment['encounter_id'])
#       appointment.update(encounter_id: rds_appointment['encounter_id'], appointment_date: rds_appointment['value_datetime'],
#                          voided: rds_appointment['voided'], voided_by: rds_appointment['voided_by'],
#                          creator: rds_appointment['creator'], voided_date: rds_appointment['date_voided'],
#                          void_reason: rds_appointment['void_reason'], created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'),
#                          updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

#       puts "Successfully updated appointment details with record for person #{rds_appointment['person_id']}"
#     end
#   end
# end

def populate_prescription
  last_updated = get_last_updated('MedicationPrescription')
  prescription = ActiveRecord::Base.connection.select_all <<~SQL
      SELECT * FROM #{@rds_db}.orders o
    JOIN #{@rds_db}.drug_order d on o.order_id = d.order_id where o.updated_at >= '#{last_updated}'
    AND o.order_type_id = 1;
  SQL

  (prescription || []).each do |rds_prescription|
    puts "processing person_id #{rds_prescription['patient_id']}"
    if MedicationPrescription.find_by(medication_prescription_id: rds_prescription['order_id']).blank?
      MedicationPrescription.create(medication_prescription_id: rds_prescription['order_id'], drug_id: rds_prescription['drug_inventory_id'],
                                    encounter_id: rds_prescription['encounter_id'],
                                    start_date: rds_prescription['start_date'], end_date: rds_prescription['auto_expire_date'],
                                    instructions: rds_prescription['instructions'], voided: rds_prescription['voided'],
                                    voided_by: rds_prescription['voided_by'], voided_date: rds_prescription['date_voided'],
                                    void_reason: rds_prescription['void_reason'], app_date_created: rds_prescription['date_created'],
                                    app_date_updated: rds_prescription['date_changed'])

      puts "Successfully populated medication prescription details with record for person #{rds_prescription['patient_id']}"
    else
      medication_prescription = MedicationPrescription.find_by(medication_prescription_id: rds_prescription['order_id'])
      medication_prescription.update(drug_id: rds_prescription['drug_inventory_id'], encounter_id: rds_prescription['encounter_id'],
                                     start_date: rds_prescription['start_date'], end_date: rds_prescription['auto_expire_date'],
                                     instructions: rds_prescription['instructions'], voided: rds_prescription['voided'],
                                     voided_by: rds_prescription['voided_by'], voided_date: rds_prescription['date_voided'],
                                     void_reason: rds_prescription['void_reason'], created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'),
                                     updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated medication prescription details with record for person #{rds_prescription['patient_id']}"
    end
  end
end

def populate_dispensation
  last_updated = get_last_updated('MedicationDispensation')
  prescribed_drug_id = ActiveRecord::Base.connection.select_all <<SQL
  SELECT medication_prescription_id FROM medication_prescriptions;
SQL
  drug_dispensed = ActiveRecord::Base.connection.select_all <<SQL
  SELECT quantity,orders.date_created,orders.voided,orders.voided_by,orders.date_voided, orders.void_reason,orders.patient_id
  FROM #{@rds_db}.orders
  INNER JOIN #{@rds_db}.drug_order  ON orders.order_id = drug_order.order_id
  WHERE (orders.updated_at >= '#{last_updated}');
SQL
  dispensations = ''

  (prescribed_drug_id || []).each do |ids_prescribed_drug|
    (drug_dispensed || []).each do |rds_dispensed_drug|
      puts "Processing dispensation record for person #{rds_dispensed_drug['patient_id']}"
       dispensations = "(#{rds_dispensed_drug['quantity']}, #{ids_prescribed_drug['medication_prescription_id']},
                        #{rds_dispensed_drug['voided']},#{rds_dispensed_drug['voided_by']}, #{rds_dispensed_drug['date_voided']},
                        #{rds_dispensed_drug['void_reason']}, #{rds_dispensed_drug['date_created']},
                                    app_date_updated: ''),"

      puts "Successfully populated medication dispensation details with record for person #{rds_dispensed_drug['patient_id']}"
    end
  end
end

def get_related_people
  last_updated = get_last_updated('Relationship')

  ActiveRecord::Base.connection.select_all <<QUERY
  SELECT * from #{@rds_db}.relationship where updated_at >= '#{last_updated}'
QUERY
end

def populate_relationships
  (get_related_people || []).each(&method(:ids_relationship))
end

def populate_adherence
  last_updated = get_last_updated('MedicationAdherence')
  medication_prescribed_id = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM medication_prescriptions;
SQL
  (medication_prescribed_id || []).each do |ids_prescribed_drug|
    drug_dispensed_id = ids_prescribed_drug['drug_id'].to_i # we need to include an order id which is a unique and we will need to compare in obs table
    prescription_drug_adherence = ActiveRecord::Base.connection.select_all <<SQL
      SELECT oo.person_id,oo.value_text AS  adherence_in_percentage, date(oo.obs_datetime) as visit_date,dg.drug_id as rds_drug_id
      FROM #{@rds_db}.obs oo
      LEFT JOIN #{@rds_db}.orders o ON oo.order_id = o.order_id
      LEFT JOIN #{@rds_db}.drug_order d ON o.order_id = d.order_id
      LEFT JOIN #{@rds_db}.drug dg ON d.drug_inventory_id = dg.drug_id
      WHERE oo.concept_id = 6987 and dg.drug_id = #{drug_dispensed_id};
SQL
    # where clause should read WHERE oo.concept_id = 6987 and ids_prescribed_drug['order_id'] = oo.order_id;
    (prescription_drug_adherence || []).each do |rds_drug_adherence|
      puts "Processing adherence record for person #{rds_drug_adherence['person_id']}"
      MedicationAdherence.create(medication_dispensation_id: ids_prescribed_drug['medication_prescription_id'], drug_id: ids_prescribed_drug['drug_id'],
                                 adherence: rds_drug_adherence['adherence_in_percentage'], voided: ids_prescribed_drug['voided'],
                                 voided_by: ids_prescribed_drug['voided_by'], voided_date: ids_prescribed_drug['date_voided'],
                                 void_reason: ids_prescribed_drug['void_reason'], app_date_created: ids_prescribed_drug['date_created'],
                                 app_date_updated: ids_prescribed_drug['date_changed'])

      puts "Successfully populated medication adherence details with record for person #{rds_drug_adherence['person_id']}"
    end
  end
end

def get_people
  last_updated = get_last_updated('PersonNames')
  all_people = ActiveRecord::Base.connection.select_all <<SQL
  SELECT * FROM people
  WHERE updated_at >= '#{last_updated}';
SQL
  all_people.each do |person_details|
    person_id_exist = DeIdentifiedIdentifier.find_by(person_id: person_details['person_id'])

    ## TODO: Write code to handle existing person_id
    npid = person_details['person_id']
    sid = create_sid

    DeIdentifiedIdentifier.create(identifier: sid, person_id: npid, voided: person_details['voided'], voided_by: person_details['voided_by'],
                                  voided_date: person_details['date_voided'], void_reason: person_details['void_reason'],
                                  app_date_created: person_details['app_date_created'], app_date_updated: person_details['app_date_updated'])

    puts "Successfully populated De_Identified identifier details with record for person #{person_details['person_id']}"
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
  #populate_vitals
  populate_patient_history
  populate_symptoms
  populate_side_effects
  populate_presenting_complaints
  populate_tb_statuses
  #populate_outcomes
  populate_family_planning
  #populate_appointment
  # populate_prescription
  # populate_lab_orders
  # populate_occupation
  # populate_dispensation
  # populate_relationships
  # populate_hiv_staging_info
  # populate_precription_has_regimen
  # populate_lab_test_results
  # initiate_de_duplication
  # get_people

  if File.file?('/tmp/ids_builder.lock')
    FileUtils.rm '/tmp/ids_builder.lock'
  end
end

methods_init
