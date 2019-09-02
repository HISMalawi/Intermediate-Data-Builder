# frozen_string_literal: true

# Process IDS vitals functions

def vital_value_coded(vital)
  puts "Processing Vitals for person_id: #{vital['person_id']}"

  concept_id = get_master_def_id(vital['concept_id'], 'concept_name')
  value_coded = get_master_def_id(vital['value_coded'], 'concept_name')

  vital = handle_commons(vital)


  vital = "(#{vital['obs_id'].to_i},
                    #{concept_id.to_i},
                    #{vital['encounter_id'].to_i},
                    #{value_coded.to_i},
                    #{vital['value_numeric'].to_i},
                    '#{vital['value_text']}',
                    '#{vital['value_modifier']}',
                    0,
                    0,
                    #{vital['voided'].to_i},
                    #{vital['voided_by']},
                    #{vital['date_voided']},
                   '#{vital['void_reason']}',
                    #{vital['creator'].to_i},
                    #{vital['date_created']},
                    #{vital['date_changed']}),"

  return vital
end
