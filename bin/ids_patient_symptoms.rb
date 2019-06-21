def ids_patient_symptoms(patient_symptom)
  ids_patient_symptoms = Symptom.find_by(encounter_id: patient_symptom['encounter_id'], concept_id: patient_symptom['concept_id'])

  concept_id = get_master_def_id(patient_symptom['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_symptom['value_coded'], 'concept_name')

  if ids_patient_history.blank?
    puts "Creating patient symptom for #{patient_symptom['person_id']}"
    ids_patient_symptoms = Symptom.new
    ids_patient_symptoms.concept_id = concept_id
    ids_patient_symptoms.encounter_id = patient_symptom['encounter_id']
    ids_patient_symptoms.value_coded = value_coded
  else
    puts "Updating patient symptom for #{patient_symptom['person_id']}"
    ids_patient_symptoms.concept_id = concept_id
    ids_patient_symptoms.encounter_id = patient_symptom['encounter_id']
    ids_patient_symptoms.value_coded = value_coded
  end
  ids_patient_symptoms.save!
  update_last_update('Symptoms', patient_symptom['updated_at'])
end
