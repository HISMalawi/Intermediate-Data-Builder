def process_encounter(rds_encounter)
  puts "processing Encounter for person_id #{rds_encounter['patient_id']}"
  rds_prog_id = rds_encounter['program_id']
  program_name = ActiveRecord::Base.connection.select_all <<SQL
    SELECT name FROM #{@rds_db}.program  WHERE program_id = #{rds_prog_id}  limit 1
SQL
  rds_encounter_type_id = rds_encounter['encounter_type']
  rds_encounter_type = ActiveRecord::Base.connection.select_all <<SQL
    SELECT name FROM #{@rds_db}.encounter_type WHERE encounter_type_id = #{rds_encounter_type_id} limit 1
SQL
  ids_encounter_type_name = rds_encounter_type.first
  ids_prog_name = program_name.first
  master_definition_prog_id = MasterDefinition.find_by(definition: ids_prog_name['name'])
  master_definition_encounter_id = MasterDefinition.find_by(definition: ids_encounter_type_name['name'])

  rds_encounter = handle_commons(rds_encounter)

  encounter = "(#{rds_encounter['encounter_id'].to_i},
               #{master_definition_encounter_id['master_definition_id'].to_i},
         	   #{master_definition_prog_id['master_definition_id'].to_i},
               #{rds_encounter['patient_id'].to_i},
        	   '#{rds_encounter['encounter_datetime'].strftime("%Y-%m-%d %H:%M:%S")}',
               #{rds_encounter['voided'].to_i},
              #{rds_encounter['voided_by']},
              #{rds_encounter['date_voided']},
              '#{rds_encounter['void_reason']}',
              #{rds_encounter['creator'].to_i},
               #{rds_encounter['date_created']},
               #{rds_encounter['date_changed']}),"

  return encounter
end