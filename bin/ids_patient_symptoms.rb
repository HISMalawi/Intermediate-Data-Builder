def ids_patient_symptoms(patient_symptom)
<<<<<<< HEAD
  puts "processing Symptoms for person ID #{patient_symptom['person_id']}"
=======
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d

  ids_patient_symptoms = Symptom.find_by_symptom_id(patient_symptom['obs_id'])

  concept_id = get_master_def_id(patient_symptom['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_symptom['value_coded'], 'concept_name')

<<<<<<< HEAD
  if ids_patient_symptoms && check_latest_record(patient_symptom, ids_patient_symptoms)
    puts "Updating patient symptom for #{patient_symptom['person_id']}"
=======
  patient_symptom = handle_commons(patient_symptom)

  if ids_patient_symptoms && check_latest_record(patient_symptom, ids_patient_symptoms)
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
    ids_patient_symptoms.update(concept_id: concept_id,
                                encounter_id: patient_symptom['encounter_id'],
                                value_coded: value_coded,
                                voided: patient_symptom['voided'],
                                voided_by: patient_symptom['voided_by'],
                                voided_date: patient_symptom['date_voided'],
                                void_reason: patient_symptom['void_reason'],
<<<<<<< HEAD
=======
                                creator: pregnant['creator'],
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
                                app_date_created: patient_symptom['date_created'],
                                app_date_updated: patient_symptom['date_changed'])
    
  elsif ids_patient_symptoms.blank? 
    begin
<<<<<<< HEAD
      puts "Creating patient symptom for #{patient_symptom['person_id']}"
=======
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      ids_patient_symptoms                   = Symptom.new
      ids_patient_symptoms.symptom_id        = patient_symptom['obs_id']
      ids_patient_symptoms.concept_id        = concept_id
      ids_patient_symptoms.encounter_id      = patient_symptom['encounter_id']
      ids_patient_symptoms.value_coded       = value_coded
      ids_patient_symptoms.voided            = patient_symptom['voided']
      ids_patient_symptoms.voided_by         = patient_symptom['voided_by'],
      ids_patient_symptoms.voided_date       = patient_symptom['date_voided']
      ids_patient_symptoms.void_reason       = patient_symptom['void_reason']
<<<<<<< HEAD
=======
      ids_patient_symptoms.creator           = patient_symptom['creator']
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      ids_patient_symptoms.app_date_created  = patient_symptom['date_created']
      ids_patient_symptoms.app_date_updated  = patient_symptom['date_changed']

      if ids_patient_symptoms.save
<<<<<<< HEAD
        puts 'Successfully saved patient symptoms'
        remove_failed_record('symptoms', patient_symptom['obs_id'].to_i)
      else
        puts 'Failed to save patient symptoms. Logging'
=======
        remove_failed_record('symptoms', patient_symptom['obs_id'].to_i)
      else
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      end        
    rescue Exception => e
      log_error_records('symptoms', patient_symptom['obs_id'].to_i, e)
    end
  end
<<<<<<< HEAD

  update_last_update('Symptom', patient_symptom['updated_at'])
=======
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
end
