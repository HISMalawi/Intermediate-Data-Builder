# frozen_string_literal: true

# frozen_string_literal: true

def ids_diagnosis_person(diag, primary_diagnosis, secondary_diagnosis)
  value_coded = get_master_def_id(diag['value_coded'], 'concept_name')
  
  diag = handle_commons(diag)
  diagnosis = Diagnosis.find_by_diagnosis_id(diag['diagnosis_id'])

  primary_diag  = (diag['concept_id'] == primary_diagnosis ? value_coded : '')
  secondary_diag = (diag['concept_id'] == secondary_diagnosis ? value_coded : '')

  if diagnosis && check_latest_record(diag, diagnosis)    
    diagnosis.update(
    encounter_id: diag['encounter_id'].to_i,
    primary_diagnosis: primary_diag.to_i,
    secondary_diagnosis: secondary_diag.to_i,
    voided: diag['voided'].to_i, 
    voided_by: diag['voided_by'].to_i,
    voided_date: diag['date_voided'],
    void_reason: diag['void_reason'],
    creator: diag['creator'].to_i, 
    app_date_created: diag['date_created'],
    app_date_updated: diag['date_changed'])   
  else
    begin
     Diagnosis.create(
        diagnosis_id: diag['obs_id'].to_i,
        encounter_id: diag['encounter_id'].to_i,
        primary_diagnosis: primary_diag.to_i,
        secondary_diagnosis: secondary_diag.to_i,
        voided: diag['voided'].to_i, 
        voided_by: diag['voided_by'].to_i,
        voided_date: diag['date_voided'],
        void_reason: diag['void_reason'],
        creator: diag['creator'].to_i, 
        app_date_created: diag['date_created'],
        app_date_updated: diag['date_changed']) 

      remove_failed_record('diagnosis', diag['obs_id'].to_i)
    rescue Exception => e
      log_error_records('diagnosis', diag['obs_id'].to_i, e)
    end
  end
end
