# frozen_string_literal: true

def ids_family_planning(family_planning)
  puts "Processing Patient Symptoms for person_id: #{family_planning['person_id']}"

  concept_id = get_master_def_id(family_planning['concept_id'], 'concept_name')
  value_coded = get_master_def_id(family_planning['value_coded'], 'concept_name')

 family_planning = handle_commons(patient_symptom)


  family_planning = "(#{family_planning['obs_id'].to_i},
                    #{concept_id.to_i},
                    #{family_planning['encounter_id'].to_i},
                    #{value_coded.to_i},
                    #{family_planning['voided'].to_i},
                    #{family_planning['voided_by']},
                    #{family_planning['date_voided']},
                   '#{family_planning['void_reason']}',
                    #{family_planning['creator'].to_i},
                    #{family_planning['date_created']},
                    #{family_planning['date_changed']}), "

  return family_planning
end

