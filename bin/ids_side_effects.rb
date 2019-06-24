def ids_side_effects(patient_side_effect)
  ids_side_effects = SideEffect.find_by(encounter_id: patient_side_effect['encounter_id'], concept_id: patient_side_effect['concept_id'])

  concept_id = get_master_def_id(patient_side_effect['concept_id'], 'concept_name')
  value_coded = get_master_def_id(patient_side_effect['value_coded'], 'concept_name')

  if ids_side_effects.blank?
    puts "Creating patient side effects for #{patient_side_effect['person_id']}"
    ids_side_effects = SideEffect.new
    ids_side_effects.concept_id = concept_id
    ids_side_effects.encounter_id = patient_side_effect['encounter_id']
    ids_side_effects.value_coded = value_coded
    ids_side_effects.app_date_created = patient_side_effect['created_at']
  else
    puts "Updating patient side effects for #{patient_side_effect['person_id']}"
    ids_side_effects.concept_id = concept_id
    ids_side_effects.encounter_id = patient_side_effect['encounter_id']
    ids_side_effects.value_coded = value_coded
    ids_side_effects.app_date_created = patient_side_effect['created_at']
    ids_side_effects.app_date_updated = patient_side_effect['updated_at'] rescue nil
  end
  ids_side_effects.save!
  update_last_update('SideEffect', patient_side_effect['updated_at'])
end

