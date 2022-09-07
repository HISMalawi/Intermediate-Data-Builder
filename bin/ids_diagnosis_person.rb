# frozen_string_literal: true

<<<<<<< HEAD
def ids_diagnosis_person(diag, primary_diagnosis, secondary_diagnosis)
  diagnosis = Diagnosis.find_by_encounter_id(diag['encounter_id'])
  if diagnosis && diag['encounter_datetime'].to_date >
                  (diagnosis['app_date_updated'] ||
                   diagnosis['app_date_created']).to_date
    puts 'Update code not yet available'
    assign_data(diag)
    diagnosis.update
  else
    diagnosis = Diagnosis.new
    assign_data(diag)
    if diagnosis.save
      puts "Successfully populated diagnosis
            with person id #{diag['person_id']}"
    else
      puts "Failed to populated diagnosis with person id #{diag['person_id']}"
    end
  end
  update_last_update('Diagnosis', diag['updated_at'])
end

def assign_data(diag)
  value_coded = get_master_def_id(diag[:value_coded], 'concept_name')
  diagnosis.encounter_id = diag['encounter_id']
  diagnosis.primary_diagnosis = (
  diag['concept_id'] == primary_diagnosis ? value_coded : '')
  diagnosis.secondary_diagnosis = (
  diag['concept_id'] == secondary_diagnosis ? value_coded : '')
  diagnosis.app_date_created = diag['encounter_datetime']
=======
# frozen_string_literal: true

def ids_diagnosis_person(diag)
 primary_diagnosis = 6542
 secondary_diagnosis = 6543

  value_coded = get_master_def_id(diag['value_coded'], 'concept_name')
  
  diag = handle_commons(diag)
  diagnosis = Diagnosis.find_by_diagnosis_id(diag['obs_id'])

  primary_diag  = (diag['concept_id'] == primary_diagnosis ? value_coded : '')
  secondary_diag = (diag['concept_id'] == secondary_diagnosis ? value_coded : '')

  if diagnosis.blank?
    begin
     Diagnosis.create(
        diagnosis_id: diag['obs_id'].to_i,
        encounter_id: diag['encounter_id'].to_i,
        primary_diagnosis: primary_diag,
        secondary_diagnosis: secondary_diag,
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
  elsif check_latest_record(diag, diagnosis)
    diagnosis.update(
    encounter_id: diag['encounter_id'].to_i,
    primary_diagnosis: primary_diag,
    secondary_diagnosis: secondary_diag,
    voided: diag['voided'].to_i, 
    voided_by: diag['voided_by'].to_i,
    voided_date: diag['date_voided'],
    void_reason: diag['void_reason'],
    creator: diag['creator'].to_i, 
    app_date_created: diag['date_created'],
    app_date_updated: diag['date_changed'])  
  end
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
end
