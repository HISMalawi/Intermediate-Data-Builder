# If fails, include it in the ids_builder file just before the populate_patient_history method
def ids_patient_history(patient_history)
  puts "processing History for person ID #{patient_history['person_id']}"

  ids_patient_history = PatientHistory.find_by_history_id(patient_history['obs_id'])

  concept_id = get_master_def_id(patient_history['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_history['value_coded'], 'concept_name')

  if ids_patient_history
    if check_latest_record(patient_history, ids_patient_history)

      puts "Updating patient history for #{patient_history['person_id']}"
      ids_patient_history.update(concept_id: concept_id,
                                 encounter_id: patient_history['encounter_id'],
                                 value_coded: value_coded,
                                 voided: patient_history['voided'],
                                 voided_by: patient_history['voided_by'],
                                 voided_date: patient_history['date_voided'],
                                 void_reason: patient_history['void_reason'],
                                 app_date_created: patient_history['date_created'],
                                 app_date_update: patient_history['date_changed']                                 
                                 )
    end
  else
    begin
      puts "Creating patient history for #{patient_history['person_id']}"
      ids_patient_history                       = PatientHistory.new
      ids_patient_history.history_id            = patient_history['obs_id']
      ids_patient_history.concept_id            = concept_id
      ids_patient_history.encounter_id          = patient_history['encounter_id']
      ids_patient_history.value_coded           = value_coded
      ids_patient_history.voided                = patient_history['voided']
      ids_patient_history.voided_by             = patient_history['voided_by']
      ids_patient_history.voided_date           = patient_history['date_voided']
      ids_patient_history.void_reason           = patient_history['void_reason']
      ids_patient_history.app_date_created      = patient_history['date_created']
      ids_patient_history.app_date_updated      = patient_history['date_changed']

      if ids_patient_history.save
        puts 'Successfully saved patient history'
        remove_failed_record('person_history', patient_history['obs_id'].to_i)
      else
        puts 'Failed to save patient history'
      end
        
    rescue Exception => e
      log_error_records('person_history', patient_history['obs_id'].to_i, e)
    end
    
  end
  update_last_update('PatientHistory', patient_history['updated_at'])
end