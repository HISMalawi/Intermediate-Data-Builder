def populate_regimen
    last_updated = get_last_updated('Regimen')

  patients = ActiveRecord::Base.connection.select_all <<SQL
  SELECT distinct p.patient_id, p.updated_at FROM #{@rds_db}.patient p join #{@rds_db}.patient_program pp on p.patient_id = pp.patient_id
  JOIN #{@rds_db}.patient_state ps ON pp.patient_program_id = ps.patient_program_id 
WHERE p.updated_at >= '#{last_updated}' AND pp.program_id = 1 AND p.voided = 0 AND pp.voided = 0  
AND ps.state = 7 AND ps.voided = 0 order by p.updated_at;
SQL

  patients.each do |patient|
    puts "processing Regimen info for person_id #{patient['patient_id']}"

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