# frozen_string_literal: true

def ids_presenting_complaints(presenting_complaint)
puts "Processing Patient Symptoms for person_id: #{presenting_complaint['person_id']}"

  concept_id = get_master_def_id(presenting_complaint['concept_id'], 'concept_name')
  value_coded = get_master_def_id(presenting_complaint['value_coded'], 'concept_name')

  presenting_complaint = handle_commons(patient_symptom)


  presenting_complaint = "(#{presenting_complaint['obs_id'].to_i},
                    #{concept_id.to_i},
                    #{presenting_complaint['encounter_id'].to_i},
                    #{value_coded.to_i},
                    #{presenting_complaint['voided'].to_i},
                    #{presenting_complaint['voided_by']},
                    #{presenting_complaint['date_voided']},
                   '#{presenting_complaint['void_reason']}',
                    #{presenting_complaint['creator'].to_i},
                    #{presenting_complaint['date_created']},
                    #{presenting_complaint['date_changed']}), "

  return presenting_complaint

end
