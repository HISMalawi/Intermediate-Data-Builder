# frozen_string_literal: true

def ids_family_planning(family_planning)
  puts "processing Family Planning for person ID #{family_planning['person_id']}"

  ids_family_planning = FamilyPlanning.find_by_family_planning_id(family_planning['obs_id'])

  concept_id = get_master_def_id(family_planning['concept_id'], 'concept_name')
  value_coded = get_master_def_id(family_planning['value_coded'], 'concept_name')

  if ids_family_planning && check_latest_record(family_planning, ids_family_planning)
    puts "Updating family planning for #{family_planning['person_id']}"
    ids_family_planning.update(
      concept_id:  concept_id,
      encounter_id:  family_planning['encounter_id'],
      value_coded:  value_coded,
      value_coded:  value_coded,
      voided:  family_planning['voided'],
      voided_by:  family_planning['voided_by'],
      voided_date:  family_planning['date_voided'],
      void_reason:  family_planning['void_reason'],
      app_date_created:  family_planning['date_created'],
      app_date_updated:  family_planning['date_changed']
      )

  elsif ids_family_planning.blank?
    begin
   puts "Creating family planning for #{family_planning['person_id']}"
      ids_family_planning                    = FamilyPlanning.new
      ids_family_planning.family_planning_id = family_planning['obs_id']
      ids_family_planning.concept_id         = concept_id
      ids_family_planning.encounter_id       = family_planning['encounter_id']
      ids_family_planning.value_coded        = value_coded
      ids_family_planning.value_coded        = value_coded
      ids_family_planning.voided             = family_planning['voided']
      ids_family_planning.voided_by          = family_planning['voided_by']
      ids_family_planning.voided_date        = family_planning['date_voided']
      ids_family_planning.void_reason        = family_planning['void_reason']
      ids_family_planning.app_date_created   = family_planning['date_created']
      ids_family_planning.app_date_updated   = family_planning['date_changed']

      if ids_family_planning.save
        puts 'Saved family planning'
        remove_failed_record('family_planning', family_planning['obs_id'].to_i)
      else
        puts 'Failed to save family planning. Logging'
      end
    rescue Exception => e
      log_error_records('family_planning', family_planning['obs_id'].to_i, e)
    end
  end

  update_last_update('FamilyPlanning', family_planning['updated_at'])
end

