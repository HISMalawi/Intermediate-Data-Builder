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
require_relative 'ids_hts_results_given'

@rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']
File.open("#{Rails.root}/log/last_update.yml", 'w') unless File.exist?("#{Rails.root}/log/last_update.yml") # Create a tracking file if it does not exist
@last_updated = YAML.load_file("#{Rails.root}/log/last_update.yml")
@batch_size = 1_000
@threshold = 85

def get_all_rds_peoples
  last_updated = get_last_updated('Person')

  rds_people = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person WHERE updated_at >= '#{last_updated}' ORDER BY updated_at;
QUERY
  rds_people
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

def populate_people
  last_updated = get_last_updated('People')
  query = "SELECT * FROM #{@rds_db}.person WHERE updated_at >= '#{last_updated}' ORDER BY updated_at "

   fetch_data_P(query, 'ids_people', 'People') 
end


def populate_person_names
  last_updated = get_last_updated('PersonNames')

  query = "SELECT * FROM #{@rds_db}.person_name WHERE person_name_id 
           IN #{load_error_records('person_name')} OR updated_at >= '#{last_updated}'
           ORDER BY updated_at "

 
  fetch_data_P(query, 'ids_person_names', 'PersonNames')
end 

def ids_person_names(person_name)
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
           WHERE updated_at >= '#{last_updated}'
           group by person_id
           ORDER BY updated_at "

  fetch_data_P(query, 'ids_contact_details', 'PersonAttribute')
end

def ids_contact_details(person_attribute)
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

   person_attribute = handle_commons(person_attribute)

   contact_exist = ContactDetail.find_by(person_id: person_attribute['person_id'])
    
      if contact_exist.blank?
        begin
            contact_detail = ContactDetail.new
            contact_detail.person_id = person_attribute['person_id']
            contact_detail.home_phone_number = home_phone_number
            contact_detail.cell_phone_number = cell_phone_number
            contact_detail.work_phone_number = work_phone_number
            contact_detail.creator = person_attribute['creator'].to_i
            contact_detail.voided = person_attribute['voided'].to_i
            contact_detail.voided_by = person_attribute['voided_by'].to_i
            contact_detail.voided_date = person_attribute['date_voided']
            contact_detail.void_reason = person_attribute['void_reason']
            contact_detail.app_date_created = person_attribute['date_created']
            contact_detail.app_date_updated = person_attribute['date_changed']

            contact_detail.save

            remove_failed_record('person_attribute', person_attribute['person_id'].to_i)
        rescue Exception => e
          log_error_records('person_attribute', person_attribute['person_id'].to_i, e)
        end
      elsif check_latest_record(person_attribute, contact_exist)
        contact_exist.update(home_phone_number: home_phone_number,
          cell_phone_number: cell_phone_number,
          work_phone_number: work_phone_number,
          creator: person_attribute['creator'].to_i,
          voided: person_attribute['voided'].to_i,
          voided_by: person_attribute['voided_by'].to_i,
          voided_date: person_attribute['date_voided'],
          void_reason: person_attribute['void_reason'],
          app_date_created: person_attribute['date_created'],
          app_date_updated: person_attribute['date_changed'])
      end
end

def populate_encounters
  last_updated = get_last_updated('Encounter')

  query = "SELECT * FROM #{@rds_db}.encounter 
           WHERE updated_at >= '#{last_updated}'
           OR encounter_id IN #{load_error_records('encounter')} 
           ORDER BY updated_at "

  fetch_data_P(query, 'ids_encounters', 'Encounter')
end

def ids_encounters(rds_encounter)
      rds_prog_id = rds_encounter['program_id']
    program_name = ActiveRecord::Base.connection.select_all <<~SQL
     SELECT name FROM #{@rds_db}.program  WHERE program_id = #{rds_prog_id} limit 1
    SQL
      rds_encounter_type_id = rds_encounter['encounter_type']
      rds_encounter_type = ActiveRecord::Base.connection.select_all <<~SQL
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
               "#{rds_encounter['encounter_id']} "
        end
      end
end


def update_person_type
  # Updating users type in person_type table
  last_updated = get_last_updated('User')

users = ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.users WHERE updated_at >= '#{last_updated}'
    OR user_id IN #{load_error_records('user')} 
    ORDER BY updated_at
SQL

  person_type_id = 4 # person type id for user

  Parallel.each(users, progress: 'Processing Users') do |user|
    person_has_type(person_type_id, user)
  end
  update_last_update('User', users.last['updated_at'])


  

  # Updating Guardians in person type table
  last_updated = get_last_updated('Guardian')
  guardians =  ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.relationship WHERE relationship = 6 AND
    updated_at >= '#{last_updated}' 
    OR relationship_id IN #{load_error_records('guardian')}
    ORDER BY updated_at
  SQL

  person_type_id = 5 # person type id for guardian

  Parallel.each(guardians, progress: 'Processing Guardians') do |guardian|
    person_has_type(person_type_id, guardian)
  end
  update_last_update('Guardian', guardians.last['updated_at'])

  
  # Updating Patients in person type table
  last_updated = get_last_updated('Patient')
  patients =  ActiveRecord::Base.connection.select_all <<~SQL
    SELECT * FROM #{@rds_db}.patient WHERE updated_at >= '#{last_updated}'
    OR patient_id IN #{load_error_records('user')}
    ORDER BY updated_at
  SQL

  person_type_id = 1 # person type id for patient
  Parallel.each(patients, progress: 'Processing Patients') do |patient|
    person_has_type(person_type_id, patient)
  end
  update_last_update('Patient', patients.last['updated_at'])


  # Updating Provider in person type table
  last_updated = get_last_updated('Patient')

  providers =  ActiveRecord::Base.connection.select_all <<~SQL
     SELECT * FROM #{@rds_db}.users WHERE updated_at >= '#{last_updated}'
     OR user_id IN #{load_error_records('user')}
     ORDER BY updated_at
  SQL

  person_type_id = 2 # person type id for provider
  Parallel.each(providers, progress: 'Processing Providers') do |provider|
    person_has_type(person_type_id, provider)
  end
  update_last_update('Provider', providers.last['updated_at'])
end

def populate_diagnosis
  last_updated = get_last_updated('Diagnosis')
 

query = "SELECT ob.obs_id, ob.encounter_id,
        ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
        ob.void_reason, ob.date_voided, ob.creator,
        ob.date_created,ob.updated_at 
        FROM #{@rds_db}.obs ob
        WHERE (ob.concept_id IN (6542,6543)
        AND ob.updated_at >= '#{last_updated}')
        OR ob.obs_id IN #{load_error_records('diagnosis')}
        ORDER BY ob.updated_at "

  fetch_data_P(query, 'ids_diagnosis_person', 'Diagnosis')
end

def get_district_id(district)
  Location.find_by(name: district)['location_id'].to_i
end

def populate_vitals
   last_updated = get_last_updated('Vital')

   vitals = <<~SQL
    SELECT ob.* FROM #{@rds_db}.obs ob
    INNER JOIN #{@rds_db}.encounter en
    ON ob.encounter_id = en.encounter_id
    WHERE (encounter_type = 6
    AND ob.updated_at >= '#{last_updated}') 
    OR ob.obs_id IN #{load_error_records('vitals')} 
    ORDER BY ob.updated_at 
SQL
   
  fetch_data_P(vitals, 'vital_value_coded', 'Vital') 
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

  query = "
   SELECT ob.obs_id, ob.encounter_id,
   ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
   ob.void_reason, ob.date_voided, ob.creator,
   ob.date_created, ob.updated_at
   FROM #{@rds_db}.obs ob
   WHERE (concept_id in (1755,6131,7972) 
   AND updated_at >= '#{last_updated}')
   OR ob.obs_id IN #{load_error_records('pregnant_status')}
   OR (value_coded IN (1755,6131,7972)
   AND concept_id = 7563) 
   ORDER BY updated_at "

  fetch_data_P(query,  'ids_pregnant_status', 'PregnantStatus')
end

def populate_breastfeeding_status
  last_updated = get_last_updated('BreastfeedingStatus')

  query = " SELECT ob.obs_id, ob.encounter_id,
            ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
            ob.void_reason, ob.date_voided, ob.creator,
            ob.date_created, ob.updated_at FROM #{@rds_db}.obs ob WHERE (concept_id IN
            (834,5253,5579,5632,8040,5632,9538,7965,7966,8039,8859,8881,9699)
            AND updated_at >= '#{last_updated}')
            OR ob.obs_id IN #{load_error_records('breastfeeding_status')}
            OR (value_coded IN (834,5253,5579,5632,8040,5632,9538,7965,7966,8039,8859,8881,9699)
            AND concept_id = 7563)  
            ORDER BY updated_at "

  fetch_data_P(query, 'ids_breastfeeding_status', 'BreastfeedingStatus')
end

def populate_person_address
  last_updated = get_last_updated('PersonAddress')
  
  query = "SELECT * FROM #{@rds_db}.person_address WHERE
           person_address_id IN #{load_error_records('person_address')} OR
           updated_at >= '#{last_updated}'
           ORDER BY updated_at "
 
  fetch_data_P(query, 'grouped_address', 'PersonAddress')
end

def populate_patient_history
  last_updated = get_last_updated('PatientHistory')

  query = <<~SQL
        SELECT ob.obs_id, ob.encounter_id,
        ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
        ob.void_reason, ob.date_voided, ob.creator,
        ob.date_created, ob.updated_at FROM #{@rds_db}.obs ob
        INNER JOIN #{@rds_db}.encounter en
        ON ob.encounter_id = en.encounter_id 
        INNER JOIN #{@rds_db}.encounter_type et
        ON en.encounter_type = et.encounter_type_id
        WHERE (et.encounter_type_id 
        IN (SELECT encounter_type_id FROM #{@rds_db}.encounter_type WHERE name like '%history%')
        AND ob.updated_at >= '#{last_updated}') 
        OR obs_id IN #{load_error_records('patient_history')}
        ORDER BY ob.updated_at
  SQL

   fetch_data_P(query, 'ids_patient_history', 'PatientHistory') 
end

def populate_symptoms
  last_updated = get_last_updated('Symptom')

 query = <<~SQL
   SELECT ob.obs_id, ob.encounter_id,
   ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
   ob.void_reason, ob.date_voided, ob.creator,
   ob.date_created , ob.updated_at 
   FROM #{@rds_db}.obs ob
   WHERE (ob.concept_id 
   IN (SELECT concept_id 
   FROM #{@rds_db}.concept_name 
   WHERE name like '%symptoms%')
   AND ob.updated_at >= '#{last_updated}')
   OR obs_id IN #{load_error_records('symptoms')}
   ORDER BY ob.updated_at
SQL
  
  fetch_data_P(query, 'ids_patient_symptoms', 'Symptom') 
end

def populate_side_effects
  last_updated = get_last_updated('SideEffects')

   query =  <<~SQL
    SELECT ob.obs_id, ob.encounter_id,
    ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
    ob.void_reason, ob.date_voided, ob.creator,
    ob.date_created , ob.updated_at FROM #{@rds_db}.obs ob
    WHERE (concept_id IN 
    (SELECT concept_id FROM #{@rds_db}.concept_name WHERE name like '%side%')
    AND ob.updated_at >= '#{last_updated}')
    OR obs_id IN #{load_error_records('side_effects')}
    order by ob.updated_at
  SQL

  fetch_data_P(query, 'ids_side_effects', 'SideEffects')
end

def populate_presenting_complaints
  last_updated = get_last_updated('PresentingComplaints')

   query = <<~SQL
      SELECT ob.obs_id, ob.encounter_id,
           ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
           ob.void_reason, ob.date_voided, ob.creator,
           ob.date_created FROM #{@rds_db}.obs ob
           INNER JOIN #{@rds_db}.encounter en
           ON ob.encounter_id = en.encounter_id
           INNER JOIN #{@rds_db}.encounter_type et
           ON en.encounter_type = et.encounter_type_id
           WHERE (et.encounter_type_id = 122
           AND ob.updated_at >= '#{last_updated}')
           OR obs_id IN #{load_error_records('presenting_complaints')}
           ORDER BY ob.updated_at 
SQL
    
    fetch_data_P(query, 'ids_presenting_complaints', 'PresentingComplaints') 
end

def populate_tb_statuses
  last_updated = get_last_updated('TbStatus')

   query =  <<~SQL
    SELECT ob.obs_id, ob.encounter_id,
           ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
           ob.void_reason, ob.date_voided, ob.creator,
           ob.date_created , ob.updated_at FROM #{@rds_db}.obs ob
           WHERE (concept_id = 7459
           AND ob.updated_at >= '#{last_updated}')
           OR obs_id IN #{load_error_records('tb_status')}
           ORDER BY ob.updated_at 
SQL
    fetch_data_P(query, 'ids_tb_statuses', 'TbStatus')
end

def populate_family_planning
  last_updated = get_last_updated('FamilyPlanning')

   query = <<~SQL
    SELECT ob.obs_id, ob.encounter_id,
           ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
           ob.void_reason, ob.date_voided, ob.creator,
           ob.date_created FROM #{@rds_db}.obs ob
            WHERE (concept_id IN
            (SELECT concept_id FROM
            #{@rds_db}.concept_name
            WHERE name like '%family planning%')
            AND ob.updated_at >= '#{last_updated}')
            OR obs_id IN #{load_error_records('famiy_planning')} 
            ORDER BY ob.updated_at 
SQL

  fetch_data_P(query, 'ids_family_planning', 'FamilyPlanning')
end

def populate_outcomes
  last_updated = get_last_updated('Outcome')

   query = <<~SQL
   SELECT pp.patient_id, pp.updated_at, pws.* FROM #{@rds_db}.patient_program pp
           JOIN #{@rds_db}.patient_state ps 
           ON pp.patient_program_id = ps.patient_program_id
           JOIN  #{@rds_db}.program_workflow pw 
           ON pp.program_id = pw.program_id
           JOIN #{@rds_db}.program_workflow_state pws 
           ON pw.program_workflow_id = pws.program_workflow_id
           WHERE pp.updated_at >= '#{last_updated}' 
           ORDER BY pp.updated_at 
SQL
    
   fetch_data_P(query, 'ids_outcomes', 'Outcome') 
end

def populate_occupation
  last_updated = get_last_updated('Occupation')

   query = <<~SQL
    SELECT * FROM #{@rds_db}.person_attribute 
            WHERE (person_attribute_type_id = 13
            AND updated_at >= '#{last_updated}')
            OR person_attribute_id IN #{load_error_records('occupation')} 
            ORDER BY updated_at 
SQL


   fetch_data_P(query, 'ids_occupation', 'Occupation')
end
    
  def ids_occupation(rds_occupation)

    rds_occupation = handle_commons (rds_occupation)

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
        person_occupation.creator     = rds_occupation['creator']
        person_occupation.app_date_created = rds_occupation['date_created']
        person_occupation.app_date_updated = rds_occupation['date_changed']
        person_occupation.save

          remove_failed_record('occupation', rds_occupation['person_attribute_id'])
      rescue Exception => e
        log_error_records('occupation', rds_occupation['person_attribute_id'].to_i, e)
      end
    elsif check_latest_record(rds_occupation, occupation_exists)
      person_occupation.update(occupation: rds_occupation['value'],
                               person_id: rds_occupation['person_id'], 
                               voided: rds_occupation['voided'],
                               voided_by: rds_occupation['voided_by'], 
                               voided_date: rds_occupation['date_voided'],
                               void_reason: rds_occupation['void_reason'],
                               creator: rds_occupation['creator'], 
                               app_date_created: rds_occupation['date_created'],
                               app_date_updated: rds_occupation['date_changed']) 
    end
  end

def populate_appointment
  last_updated = get_last_updated('Appointment')

   query = <<~SQL
     SELECT ob.obs_id, ob.encounter_id,
     ob.concept_id, ob.value_coded,ob.voided, ob.voided_by,
     ob.void_reason, ob.date_voided, ob.creator,
     ob.date_created, ob.value_datetime , ob.updated_at FROM #{@rds_db}.obs ob 
     JOIN #{@rds_db}.encounter en
     ON ob.encounter_id = en.encounter_id
     WHERE (en.encounter_type = 7
     AND ob.updated_at >= '#{last_updated}')
     OR obs_id IN #{load_error_records('appointment')} 
     ORDER BY ob.updated_at 
SQL
    
    fetch_data_P(query, 'ids_appointment', 'Appointment') 
end

def populate_prescription
  last_updated = get_last_updated('MedicationPrescription')

   query =  <<~SQL
    SELECT o.order_id, o.encounter_id,d.drug_inventory_id,o.start_date,
    o.auto_expire_date, o.instructions,o.voided, o.voided_by,
    o.void_reason, o.date_voided, o.date_created, o.updated_at
    FROM #{@rds_db}.orders o
    JOIN #{@rds_db}.drug_order d on o.order_id = d.order_id
    WHERE (o.order_type_id = 1   
    AND o.updated_at >= '#{last_updated}')
    OR o.order_id IN #{load_error_records('prescription')}
    ORDER BY o.updated_at
   SQL

    fetch_data_P(query, 'ids_prescription', 'MedicationPrescription')
end

def populate_dispensation
  last_updated = get_last_updated('MedicationDispensation')

  query = <<~SQL
    SELECT o.order_id, quantity, o.date_created, o.voided,
    o.voided_by,o.date_voided, o.void_reason,o.patient_id, do.updated_at
    FROM #{@rds_db}.orders o
    INNER JOIN #{@rds_db}.drug_order do ON o.order_id = do.order_id
    WHERE (do.updated_at >= '#{last_updated}')
    OR do.order_id IN #{load_error_records('dispensation')} 
    ORDER BY o.updated_at 
SQL
  
  fetch_data_P(query, 'ids_dispensation', 'MedicationDispensation') 
end

def ids_dispensation (rds_dispensed_drug)
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

         remove_failed_record('dispensation', rds_dispensed_drug['order_id'].to_i)

      rescue Exception => e
        log_error_records('dispensation', rds_dispensed_drug['order_id'].to_i, e)
      end
     elsif check_latest_record(rds_dispensed_drug, dispensation_exist)
       dispensation_exist.update(
        quantity: rds_dispensed_drug['quantity'],
        medication_prescription_id: ids_dispensed_drug['medication_prescription_id'],
        voided: rds_dispensed_drug['voided'],
        voided_by: rds_dispensed_drug['voided_by'],
        voided_date: rds_dispensed_drug['date_voided'],
        void_reason: rds_dispensed_drug['void_reason'],
        app_date_created: rds_dispensed_drug['date_created'],
        app_date_updated: ''
        )
     end
end

def populate_relationships
  last_updated = get_last_updated('Relationship')

  query = <<~SQL 
    SELECT * from #{@rds_db}.relationship 
    WHERE relationship_id IN #{load_error_records('relationships')} 
    OR updated_at >= '#{last_updated}' 
    ORDER BY updated_at  
  SQL

  fetch_data_P(query, 'ids_relationship', 'Relationship')
end


def populate_hts_results_given
  last_updated = get_last_updated('HtsResultsGiven')
  
  query = <<~SQL
    SELECT * FROM #{@rds_db}.obs
    WHERE (updated_at >= '#{last_updated}'
    AND concept_id = 8492)
    OR obs_id IN #{load_error_records('adherence')}
    ORDER BY updated_at
  SQL

  fetch_data_P(query, 'ids_hts_result_given', 'HtsResultsGiven')
end

def populate_adherence
  last_updated = get_last_updated('MedicationAdherence')
  
  query = <<~SQL
    SELECT * FROM #{@rds_db}.obs
    WHERE (updated_at >= '#{last_updated}'
    AND concept_id = 6987)
    OR obs_id IN #{load_error_records('adherence')}
    ORDER BY updated_at
  SQL

  fetch_data_P(query, 'ids_adherence', 'MedicationAdherence')
end

def ids_adherence (ids_dispensed_drug)
    drug_dispensed_id = MedicationPrescription.find_by(
      medication_prescription_id: ids_dispensed_drug['order_id'])

    return if drug_dispensed_id.blank?

    adherence = (ids_dispensed_drug['value_numeric'] || ids_dispensed_drug['value_text'])

      adherence_exists = MedicationAdherence.find_by_adherence_id(ids_dispensed_drug['obs_id'].to_i)

      ids_dispensed_drug = handle_commons(ids_dispensed_drug)

      if adherence_exists.blank?
        begin
          MedicationAdherence.create(
            adherence_id: ids_dispensed_drug['obs_id'].to_i,
            medication_dispensation_id: ids_dispensed_drug['order_id'],
            drug_id: drug_dispensed_id['drug_id'].to_i,
            adherence: adherence.to_f,
            voided: ids_dispensed_drug['voided'],
            voided_by: ids_dispensed_drug['voided_by'], 
            voided_date: ids_dispensed_drug['date_voided'],
            void_reason: ids_dispensed_drug['void_reason'], 
            app_date_created: ids_dispensed_drug['date_created'],
            app_date_updated: ids_dispensed_drug['date_changed']
            )

        remove_failed_record('adherence', ids_dispensed_drug['obs_id'].to_i)
        
        rescue Exception => e
          log_error_records('adherence', ids_dispensed_drug['obs_id'].to_i, e)
        end

      elsif check_latest_record(ids_dispensed_drug, adherence_exists)
        adherence_exists.update(
          medication_dispensation_id: ids_dispensed_drug['order_id'],
          drug_id: drug_dispensed_id['drug_id'].to_i,
          adherence: adherence.to_f,
          voided: ids_dispensed_drug['voided'],
          voided_by: ids_dispensed_drug['voided_by'], 
          voided_date: ids_dispensed_drug['date_voided'],
          void_reason: ids_dispensed_drug['void_reason'], 
          app_date_created: ids_dispensed_drug['date_created'],
          app_date_updated: ids_dispensed_drug['date_changed']
          )
      end
end

def populate_de_identifier
  last_updated = get_last_updated('DeIdentifiedIdentifier')

  query = "SELECT * FROM people
           WHERE updated_at >= '#{last_updated}' 
           ORDER BY updated_at "

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
    update_last_update('DeIdentifiedIdentifier',person_details['updated_at'])
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
  tables = [
  'populate_person_names',
  'populate_contact_details',
  'populate_person_address',
  'update_person_type',
  'populate_encounters'
]
 
 Parallel.each(tables) do | table|
  send(table)
 end
  tables2 = [
    'populate_diagnosis',
  'populate_pregnant_status',
  'populate_breastfeeding_status',
  'populate_vitals',
  'populate_patient_history',
  'populate_symptoms',
  'populate_side_effects',
  'populate_presenting_complaints',
  'populate_tb_statuses',
  'populate_outcomes',
  'populate_family_planning',
  'populate_appointment',
  'populate_prescription',
  'populate_lab_orders',
  'populate_occupation',
  'populate_dispensation',
  'populate_adherence',
  'populate_relationships',
  'populate_hiv_staging_info',
  'populate_precription_has_regimen',
  'populate_hts_results_given'
]

Parallel.each(tables2) do | table|
  send(table)
end
    populate_lab_test_results    
    populate_de_identifier

   FileUtils.rm '/tmp/ids_builder.lock' if File.file?('/tmp/ids_builder.lock')
end

methods_init