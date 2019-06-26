# frozen_string_literal: true

def populate_hiv_staging_info
  last_updated = get_last_updated('StagingInfo')

  patients = ActiveRecord::Base.connection.select_all <<SQL
  SELECT distinct p.patient_id, p.updated_at FROM #{@rds_db}.patient p join #{@rds_db}.patient_program pp on p.patient_id = pp.patient_id
  JOIN #{@rds_db}.patient_state ps ON pp.patient_program_id = ps.patient_program_id 
WHERE p.updated_at >= '#{last_updated}' AND pp.program_id = 1 AND p.voided = 0 AND pp.voided = 0 order by p.updated_at;
SQL

  patients.each do |patient|
    puts "processing HIV info for person_id #{patient['patient_id']}"

    staging_exist = HivStagingInfo.find_by(person_id: patient['patient_id'])
    age_at_initiation = patient_age_at_initiation(patient['patient_id'])['age_at_initiation']
    age_in_days = patient_age_at_initiation(patient['patient_id'])['age_in_days']
    if staging_exist
      #Update Staging Record
      staging_exist.update(start_date: get_start_date(patient['patient_id']),
                           date_enrolled: get_date_enrolled(patient['patient_id']),
                           transfer_in: get_master_def_id(get_transfer_in(patient['patient_id'], get_date_enrolled(patient['patient_id'])), 'concept_name'),
                           re_initiated: get_master_def_id(get_transfer_in(patient['patient_id'], get_date_enrolled(patient['patient_id'])), 'concept_name'),
                           age_at_initiation: age_at_initiation,
                           age_in_days_at_initiation: age_in_days,
                           who_stage: get_who_stage(patient['patient_id']),
                           reason_for_starting: get_reason_for_starting(patient['patient_id']))
    else
      staging_info = HivStagingInfo.new
      staging_info.person_id = patient['patient_id']
      staging_info.start_date = get_start_date(patient['patient_id'])
      staging_info.date_enrolled = get_date_enrolled(patient['patient_id'])
      staging_info.transfer_in = get_master_def_id(get_transfer_in(patient['patient_id'], get_date_enrolled(patient['patient_id'])), 'concept_name')
      staging_info.re_initiated = get_master_def_id(get_transfer_in(patient['patient_id'], get_date_enrolled(patient['patient_id'])), 'concept_name')
      staging_info.age_at_initiation = age_at_initiation
      staging_info.age_in_days_at_initiation = age_in_days
      staging_info.who_stage = get_who_stage(patient['patient_id'])
      staging_info.reason_for_starting = get_reason_for_starting(patient['patient_id'])

      staging_info.save
    end
    update_last_update('StagingInfo', patient['updated_at'])
  end
end

def get_start_date(patient_id)
  start_date = ActiveRecord::Base.connection.select_one <<~SQL
    SELECT MIN(start_date) start_date FROM #{@rds_db}.patient_state s INNER JOIN
    #{@rds_db}.patient_program p ON p.patient_program_id = s.patient_program_id WHERE s.voided = 0
    AND s.state = 7 AND p.program_id = 1 AND p.patient_id = #{patient_id};
  SQL
  start_date['start_date']
end

def get_date_enrolled(patient_id)
  dispension_concept_id = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE name = 'AMOUNT DISPENSED';
SQL

  arv_concept = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE name = "ANTIRETROVIRAL DRUGS";
SQL

  date_enrolled = ActiveRecord::Base.connection.select_one <<SQL
  SELECT MIN(DATE(obs_datetime)) as date_enrolled FROM #{@rds_db}.obs WHERE person_id = #{patient_id} AND
  concept_id = #{dispension_concept_id['concept_id']} AND value_drug IN (SELECT drug_id
  FROM #{@rds_db}.drug d WHERE d.concept_id IN (SELECT cs.concept_id FROM #{@rds_db}.concept_set cs WHERE cs.concept_set = #{arv_concept['concept_id']}));
SQL

  date_enrolled['date_enrolled']
end

def get_transfer_in(patient_id, date_enrolled)
  date_art_last_taken_concept = ActiveRecord::Base.connection.select_one <<~SQL
    SELECT concept_id FROM #{@rds_db}.concept_name WHERE name ='DATE ART LAST TAKEN';
  SQL
  taken_arvs_concept = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE name ='HAS THE PATIENT TAKEN ART IN THE LAST TWO MONTHS'
SQL

  no_concept = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE name ='NO';
SQL

  yes_concept = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE name ='YES';
SQL

  check_one = ActiveRecord::Base.connection.select_one <<~SQL
    SELECT e.patient_id FROM #{@rds_db}.clinic_registration_encounter e
    INNER JOIN #{@rds_db}.ever_registered_obs AS ero ON e.encounter_id = ero.encounter_id
    INNER JOIN #{@rds_db}.obs o ON o.encounter_id = e.encounter_id AND
    o.concept_id = #{date_art_last_taken_concept['concept_id']} AND o.voided = 0 WHERE
    (o.concept_id = #{date_art_last_taken_concept['concept_id']} AND (TIMESTAMPDIFF(day, o.value_datetime, o.obs_datetime) > 14))
    AND '#{get_date_enrolled(patient_id)}' = '#{date_enrolled}' AND e.patient_id = #{patient_id} GROUP BY e.patient_id;
  SQL

  check_two = ActiveRecord::Base.connection.select_one <<~SQL
    SELECT e.patient_id FROM #{@rds_db}.clinic_registration_encounter e
      INNER JOIN #{@rds_db}.ever_registered_obs AS ero ON e.encounter_id = ero.encounter_id
      INNER JOIN #{@rds_db}.obs o ON o.encounter_id = e.encounter_id AND o.concept_id = #{taken_arvs_concept['concept_id']} AND o.voided = 0
      WHERE  (o.concept_id = #{taken_arvs_concept['concept_id']} AND o.value_coded = #{no_concept['concept_id']})
      AND '#{get_date_enrolled(patient_id)}' = '#{date_enrolled}' AND e.patient_id = #{patient_id} GROUP BY e.patient_id;
  SQL
  if check_one
    reintiated = yes_concept
  elsif check_two
    reintiated = yes_concept
  else
    reintiated = no_concept
  end
  return reintiated['concept_id']
end

def patient_age_at_initiation(patient_id)
  patient_ages_at_initiation = ActiveRecord::Base.connection.select_all <<~SQL
    select
                p.patient_id AS patient_id,
                cast('#{get_date_enrolled(patient_id)}' as date) AS date_enrolled,
                (select timestampdiff(year, pe.birthdate, min(s.start_date))) AS age_at_initiation,
                (select timestampdiff(day, pe.birthdate, min(s.start_date))) AS age_in_days
              from
                ((#{@rds_db}.patient_program p
                left join #{@rds_db}.person pe ON ((pe.person_id = p.patient_id))
                left join #{@rds_db}.patient_state s ON ((p.patient_program_id = s.patient_program_id)))
                left join #{@rds_db}.person ON ((person.person_id = p.patient_id)))
              where
                ((p.voided = 0)
                    and (s.voided = 0)
                    and (p.program_id = 1)
                    and (s.state = 7)
                    and (p.patient_id = #{patient_id}))
              group by p.patient_id
              HAVING date_enrolled IS NOT NULL;
  SQL
  return patient_ages_at_initiation.first
end

def get_who_stage(patient_id)
  concept_answer_id = ActiveRecord::Base.connection.select_one <<SQL
  SELECT value_coded, value_coded_name_id, value_text FROM #{@rds_db}.obs WHERE concept_id = 7562 AND person_id = #{patient_id};
SQL
  debugger if concept_answer_id['value_coded'].blank?
  if concept_answer_id['value_coded'] && concept_answer_id['value_coded_name_id']
    who_stage = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE concept_id = #{concept_answer_id['value_coded']} 
AND concept_name_id = #{concept_answer_id['value_coded_name_id']};
SQL
  elsif concept_answer_id['value_text']
    who_stage = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE name = '#{concept_answer_id['value_text']}';
SQL
  end

  return get_master_def_id(who_stage['concept_id'], 'concept_name')

end

def get_reason_for_starting(patient_id)
  reason_concept_id = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE name = 'Reason for ART eligibility' AND voided = 0;
SQL

  max_obs_datetime = ActiveRecord::Base.connection.select_one <<SQL
  SELECT MAX(obs_datetime) as max_date_time FROM #{@rds_db}.obs WHERE person_id = #{patient_id} AND concept_id = #{reason_concept_id['concept_id']} AND voided = 0;
SQL

  coded_concept_id = ActiveRecord::Base.connection.select_one <<SQL
  SELECT value_coded FROM #{@rds_db}.obs WHERE person_id = #{patient_id} AND concept_id = #{reason_concept_id['concept_id']} 
AND voided = 0 AND obs_datetime = '#{max_obs_datetime['max_date_time']}';
SQL
    reason_for_art_eligibility = ActiveRecord::Base.connection.select_one <<SQL
  SELECT concept_id FROM #{@rds_db}.concept_name WHERE concept_id = #{coded_concept_id['value_coded']} AND LENGTH(name) > 0;
SQL

  return get_master_def_id(reason_for_art_eligibility['concept_id'], 'concept_name')

end
