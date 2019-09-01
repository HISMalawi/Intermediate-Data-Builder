def ids_side_effects(patient_side_effect)

  puts "Processing Patient Side Effects for person_id: #{patient_side_effect['person_id']}"

  concept_id = get_master_def_id(patient_side_effect['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_side_effect['value_coded'], 'concept_name')

  patient_side_effect = handle_commons(patient_side_effect)


  patient_side_effect = "(#{patient_side_effect['obs_id'].to_i},
                    #{concept_id.to_i},
                    #{patient_side_effect['encounter_id'].to_i},
                    #{value_coded.to_i},
                    #{patient_side_effect['voided'].to_i},
                    #{patient_side_effect['voided_by']},
                    #{patient_side_effect['date_voided']},
                   '#{patient_side_effect['void_reason']}',
                    #{patient_side_effect['creator'].to_i},
                    #{patient_side_effect['date_created']},
                    #{patient_side_effect['date_changed']}),"

  return patient_side_effect
end

