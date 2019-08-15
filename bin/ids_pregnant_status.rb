def ids_pregnant_status(pregnant)
  puts "Updating Pregnant Status for person_id: #{pregnant['person_id']}"
  pregnant_status_exist = PregnantStatus.find_by(concept_id: pregnant['concept_id'],
                                                 encounter_id: pregnant['encounter_id'])

  concept_id = get_master_def_id(pregnant['concept_id'], 'concept_name')
  # TODO
  # get_master_def_id() # get_master_def_id('Pregnant?')
  value_coded = MasterDefinition.find_by_definition('Pregnant?')['master_definition_id']

  if pregnant_status_exist.blank?
    PregnantStatus.create(
      concept_id: concept_id,
      encounter_id: pregnant['encounter_id'],
      value_coded: value_coded,
      voided: pregnant['voided'],
      voided_by: pregnant['voided_by'],
      voided_date: pregnant['voided_date'],
      void_reason: pregnant['void_reason'],
      app_date_created: pregnant['date_created'],
      app_date_updated: pregnant['date_updated']
      )
  elsif pregnant['date_updated'].to_date > (pregnant_status_exist['app_date_updated'] ||
        pregnant_status_exist['app_date_created']).to_date
    pregnant_status_exist.update(concept_id: concept_id, encounter_id: pregnant['encounter_id'],
                                 value_coded: value_coded, voided: pregnant['voided'],
                                 voided_by: pregnant['voided_by'], voided_date: pregnant['voided_date'],
                                 app_date_created: pregnant['date_created'], app_date_updated: pregnant['date_updated'])
  end
  update_last_update('PregnantStatus', pregnant['updated_at'])
end

