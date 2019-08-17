def ids_side_effects(patient_side_effect)

  concept_id = get_master_def_id(patient_side_effect['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_side_effect['value_coded'], 'concept_name')

  ids_side_effects = SideEffect.find_by(encounter_id: patient_side_effect['encounter_id'], concept_id: concept_id)


  if ids_side_effects
    puts "Updating patient side effects for #{patient_side_effect['person_id']}"
    ids_side_effects.update(concept_id: concept_id)
    ids_side_effects.update(encounter_id: patient_side_effect['encounter_id'])
    ids_side_effects.update(value_coded: value_coded)
    ids_side_effects.update(app_date_created: patient_side_effect['created_at'])
    ids_side_effects.update(app_date_updated: patient_side_effect['updated_at'])
  else
    begin
      puts "Creating patient side effects for #{patient_side_effect['person_id']}"
      ids_side_effects = SideEffect.new
      ids_side_effects.concept_id = concept_id
      ids_side_effects.encounter_id = patient_side_effect['encounter_id']
      ids_side_effects.value_coded = value_coded
      ids_side_effects.app_date_created = patient_side_effect['created_at']

      if ids_side_effects.save
        puts 'Successfully saved side effects'
        remove_failed_record('side_effects', patient_side_effect['obs_id'])
      else
        puts 'Failed to save side effects'
      end
    rescue Exception => e
      log_error_records('side_effects', patient_side_effect['obs_id'].to_i, e)
    end
  end

  update_last_update('SideEffects', patient_side_effect['updated_at'])
end

