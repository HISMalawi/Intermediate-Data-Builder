def ids_side_effects(patient_side_effect)
  concept_id = get_master_def_id(patient_side_effect['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_side_effect['value_coded'], 'concept_name')

  ids_side_effects = SideEffect.find_by_side_effect_id(patient_side_effect['obs_id'])

  if ids_side_effects &&
     check_latest_record(patient_side_effect, ids_side_effects)
    puts "Updating patient side effects for #{patient_side_effect['person_id']}"
    ids_side_effects.update(
      concept_id: concept_id,
      encounter_id: patient_side_effect['encounter_id'],
      value_coded: value_coded,
      voided: patient_side_effect['voided'],
      voided_by: patient_side_effect['voided_by'],
      voided_date: patient_side_effect['date_voided'],
      void_reason: patient_side_effect['void_reason'],
      app_date_created: patient_side_effect['date_created'],
      app_date_updated: patient_side_effect['date_changed'])
    
  elsif ids_side_effects.blank?
    begin
      ids_side_effects                   = SideEffect.new
      ids_side_effects.side_effect_id    = patient_side_effect['obs_id']
      ids_side_effects.concept_id        = concept_id
      ids_side_effects.encounter_id      = patient_side_effect['encounter_id']
      ids_side_effects.value_coded       = value_coded
      ids_side_effects.voided            = patient_side_effect['voided']
      ids_side_effects.voided_by         = patient_side_effect['voided_by']
      ids_side_effects.voided_date       = patient_side_effect['date_voided']
      ids_side_effects.void_reason       = patient_side_effect['void_reason']
      ids_side_effects.app_date_created  = patient_side_effect['date_created']
      ids_side_effects.app_date_updated  = patient_side_effect['date_changed']

      if ids_side_effects.save
        remove_failed_record('side_effects', patient_side_effect['obs_id'])
      else
      end
    rescue Exception => e
      log_error_records('side_effects', patient_side_effect['obs_id'].to_i, e)
    end
  end
end

