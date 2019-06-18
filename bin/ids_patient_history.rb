# If fails, include it in the ids_builder file just before the populate_patient_history method
def ids_patient_history(patient_history)
  ids_patient_history = PatientHistory.find_by(encounter_id: patient_history['encounter_id'], concept_id: patient_history['concept_id'])

  concept_id = get_master_def_id(patient_history['concept_id'])
  value_coded = get_master_def_id(patient_history['value_coded'])

  if ids_patient_history.blank?
    puts "Creating patient history for #{patient_history['person_id']}"
    ids_patient_history = PatientHistory.new
    ids_patient_history.concept_id = concept_id
    ids_patient_history.encounter_id = patient_history['encounter_id']
    ids_patient_history.value_coded = value_coded
  else
    puts "Updating patient history for #{patient_history['person_id']}"
    ids_patient_history.concept_id = concept_id
    ids_patient_history.encounter_id = patient_history['encounter_id']
    ids_patient_history.value_coded = value_coded
  end
  ids_patient_history.save!
  update_last_update('PatientHistory', patient_history['updated_at'])
end