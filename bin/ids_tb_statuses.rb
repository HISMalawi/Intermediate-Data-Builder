# frozen_string_literal: true

def ids_tb_statuses(tb_status)

  puts "Processing Patient Symptoms for person_id: #{tb_status['person_id']}"

  concept_id = get_master_def_id(tb_status['concept_id'], 'concept_name')
  value_coded = get_master_def_id(tb_status['value_coded'], 'concept_name')

  tb_status = handle_commons(patient_symptom)


  tb_status = "(#{tb_status['obs_id'].to_i},
                    #{concept_id.to_i},
                    #{tb_status['encounter_id'].to_i},
                    #{value_coded.to_i},
                    #{tb_status['voided'].to_i},
                    #{tb_status['voided_by']},
                    #{tb_status['date_voided']},
                   '#{tb_status['void_reason']}',
                    #{tb_status['creator'].to_i},
                    #{tb_status['date_created']},
                    #{tb_status['date_changed']}), "

  return tb_status
end

