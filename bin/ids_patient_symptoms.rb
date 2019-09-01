def ids_patient_symptoms(patient_symptom)

  puts "Processing Patient Symptoms for person_id: #{patient_symptom['person_id']}"

  concept_id = get_master_def_id(patient_symptom['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_symptom['value_coded'], 'concept_name')


  patient_symptom = handle_commons(patient_symptom)


  patient_symptom = "(#{patient_symptom['obs_id'].to_i},
                    #{concept_id.to_i},
                    #{patient_symptom['encounter_id'].to_i},
                    #{value_coded.to_i},
                    #{patient_symptom['voided'].to_i},
                    #{patient_symptom['voided_by']},
                    #{patient_symptom['date_voided']},
                   '#{patient_symptom['void_reason']}',
                    #{patient_symptom['creator'].to_i},
                    #{patient_symptom['date_created']},
                    #{patient_symptom['date_changed']}), "

  return patient_symptom

end
