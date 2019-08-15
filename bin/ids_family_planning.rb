# frozen_string_literal: true

def ids_family_planning(family_planning, failed_records)
  ids_family_planning = FamilyPlanning.find_by(encounter_id: family_planning['encounter_id'], concept_id: family_planning['concept_id'])

  concept_id = get_master_def_id(family_planning['concept_id'], 'concept_name')
  value_coded = get_master_def_id(family_planning['value_coded'], 'concept_name')

  if ids_family_planning
    puts "Updating family planning for #{family_planning['person_id']}"
    ids_family_planning.update(concept_id: concept_id)
    ids_family_planning.update(encounter_id: family_planning['encounter_id'])
    ids_family_planning.update(value_coded: value_coded)
  else
    begin
      puts "Creating family planning for #{family_planning['person_id']}"
      ids_family_planning = FamilyPlanning.new
      ids_family_planning.concept_id = concept_id
      ids_family_planning.encounter_id = family_planning['encounter_id']
      ids_family_planning.value_coded = value_coded
      if ids_family_planning.save
        puts 'Saved family planning'
      else
        puts 'Failed to save family planning. Logging'
      end
      if failed_records.include?(family_planning['obs_id'].to_s)
        remove_failed_record('FamilyPlanning', family_planning['obs_id'])
      end
    rescue Exception => e
      File.write('log/app_errors.log', e.message, mode: 'a')
      log_error_records('FamilyPlanning', family_planning['obs_id'].to_i)
    end
  end

  update_last_update('FamilyPlanning', family_planning['updated_at'])
end

