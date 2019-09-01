def ids_pregnant_status(pregnant)
  puts "Processing Pregnant Status for person_id: #{pregnant['person_id']}"
  
  concept_id = get_master_def_id(pregnant['concept_id'], 'concept_name')
  # TODO
  # get_master_def_id() # get_master_def_id('Pregnant?')
  value_coded = MasterDefinition.find_by_definition('Pregnant?')['master_definition_id']

  pregnant = handle_commons(pregnant)

  pregnant_status = "(#{pregnant['obs_id'].to_i},
                      #{concept_id.to_i},
                     #{pregnant['encounter_id'].to_i},
                     #{value_coded.to_i},
                     #{pregnant['voided'].to_i},
                     #{pregnant['voided_by'].to_i},
                     #{pregnant['date_voided']},
                     '#{pregnant['void_reason']}',
                     #{pregnant['date_created']},
                     #{pregnant['date_changed']}),"
 
  return pregnant_status
end
