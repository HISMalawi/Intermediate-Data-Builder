# If fails, include it in the ids_builder file just before the populate_patient_history method
def ids_patient_history(patient_history)
  puts "Creating patient history for #{patient_history['person_id']}"

  concept_id = get_master_def_id(patient_history['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_history['value_coded'], 'concept_name')


patient_history = "(#{patient_history['obs_id'].to_i},
                    #{concept_id.to_i},
                    #{patient_history['encounter_id'].to_i},
                    #{value_coded.to_i},
                    '#{patient_history['date_created']}',
                    '#{patient_history['date_created']}'), "

  return patient_history
end