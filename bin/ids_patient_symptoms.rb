def ids_patient_symptoms(patient_symptom, failed_records)
  ids_patient_symptoms = Symptom.find_by(encounter_id: patient_symptom['encounter_id'], concept_id: patient_symptom['concept_id'])

  concept_id = get_master_def_id(patient_symptom['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_symptom['value_coded'], 'concept_name')

  if ids_patient_symptoms
    puts "Updating patient symptom for #{patient_symptom['person_id']}"
    ids_patient_symptoms.update(concept_id: concept_id)
    ids_patient_symptoms.update(encounter_id: patient_symptom['encounter_id'])
    ids_patient_symptoms.update(value_coded: value_coded)
    ids_patient_symptoms.update(app_date_created: patient_symptom['created_at'])
    ids_patient_symptoms.update(app_date_update: patient_symptom['updates_at'])
  else
    begin
      puts "Creating patient symptom for #{patient_symptom['person_id']}"
      ids_patient_symptoms = Symptom.new
      ids_patient_symptoms.concept_id = concept_id
      ids_patient_symptoms.encounter_id = patient_symptom['encounter_id']
      ids_patient_symptoms.value_coded = value_coded
      ids_patient_symptoms.app_date_created = patient_symptom['created_at']

    if ids_patient_symptoms.save
      puts 'Successfully saved patient symptoms'
    else
      puts 'Failed to save patient symptoms. Logging'
    end

    if failed_records.include?(patient_symptom['obs_id'].to_s)
        remove_failed_record('PersonSymptom', patient_symptom['obs_id'])
      end
    rescue Exception => e
      File.write('log/app_errors.log', e.message, mode: 'a')
      log_error_records('PersonSymptom', patient_symptom['obs_id'].to_i)
    end
  end

  update_last_update('Symptom', patient_symptom['updated_at'])
end
