def ids_pregnant_status(pregnant)
<<<<<<< HEAD
  puts "Processing Pregnant Status for person_id: #{pregnant['person_id']}"
=======
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  pregnant_status_exist = PregnantStatus.find_by_pregnant_status_id(pregnant['obs_id'])

  concept_id = get_master_def_id(pregnant['concept_id'], 'concept_name')
  # TODO
  # get_master_def_id() # get_master_def_id('Pregnant?')
  value_coded = MasterDefinition.find_by_definition('Pregnant?')['master_definition_id']

<<<<<<< HEAD
=======
  pregnant = handle_commons(pregnant)

>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  if pregnant_status_exist.blank?
    begin
      PregnantStatus.create(
        pregnant_status_id: pregnant['obs_id'],
        concept_id: concept_id,
        encounter_id: pregnant['encounter_id'],
        value_coded: value_coded,
        voided: pregnant['voided'],
        voided_by: pregnant['voided_by'],
        voided_date: pregnant['voided_date'],
        void_reason: pregnant['void_reason'],
<<<<<<< HEAD
=======
        creator: pregnant['creator'],
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
        app_date_created: pregnant['date_created'],
        app_date_updated: pregnant['date_updated']
        )

        remove_failed_record('pregnant_status', pregnant['obs_id'].to_i)
    rescue Exception => e
      log_error_records('pregnant_status', pregnant['obs_id'].to_i, e)
    end
  elsif check_latest_record(pregnant, pregnant_status_exist)
<<<<<<< HEAD
    pregnant_status_exist.update(concept_id: concept_id, encounter_id: pregnant['encounter_id'],
                                 value_coded: value_coded, voided: pregnant['voided'],
                                 voided_by: pregnant['voided_by'], voided_date: pregnant['voided_date'],
                                 app_date_created: pregnant['date_created'], app_date_updated: pregnant['date_updated'])
  end
  update_last_update('PregnantStatus', pregnant['updated_at'])
=======
    pregnant_status_exist.update(concept_id: concept_id, 
                                 encounter_id: pregnant['encounter_id'],
                                 value_coded: value_coded, 
                                 voided: pregnant['voided'],
                                 voided_by: pregnant['voided_by'], 
                                 voided_date: pregnant['voided_date'],
                                 void_reason: pregnant['void_reason'],
                                 creator: pregnant['creator'],
                                 app_date_created: pregnant['date_created'], 
                                 app_date_updated: pregnant['date_updated'])
  end  
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
end
