def ids_hts_result_given(result_given)

  value_coded = get_master_def_id(result_given['value_coded'], 'concept_name')
  concept_id = get_master_def_id(result_given['concept_id'], 'concept_name')
  
  result_given = handle_commons(result_given)
  result = HtsResultsGiven.find_by_htsrg_id(result_given['obs_id'])

  if result.blank?
    begin
     HtsResultsGiven.create(
        htsrg_id: result_given['obs_id'].to_i,
        encounter_id: result_given['encounter_id'].to_i,
        concept_id: concept_id.to_i,
        value_coded: value_coded.to_i,
        voided: result_given['voided'].to_i, 
        voided_by: result_given['voided_by'].to_i,
        voided_date: result_given['date_voided'],
        void_reason: result_given['void_reason'],
        creator: result_given['creator'].to_i, 
        app_date_created: result_given['date_created'],
        app_date_updated: result_given['date_changed']) 

      remove_failed_record('hts_result_given', result_given['obs_id'].to_i)
    rescue Exception => e
      log_error_records('hts_result_given', result_given['obs_id'].to_i, e)
    end     
  elsif check_latest_record(result_given, result)
    result.update(
    encounter_id: result_given['encounter_id'].to_i,
    concept_id: concept_id.to_i,
    value_coded: value_coded.to_i,
    voided: result_given['voided'].to_i, 
    voided_by: result_given['voided_by'].to_i,
    voided_date: result_given['date_voided'],
    void_reason: result_given['void_reason'],
    creator: result_given['creator'].to_i, 
    app_date_created: result_given['date_created'],
    app_date_updated: result_given['date_changed'])  
  end
end