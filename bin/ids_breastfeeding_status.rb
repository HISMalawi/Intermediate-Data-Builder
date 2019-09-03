def ids_breastfeeding_status(breastfeeding_status)
  breastfeeding_status_exist = BreastfeedingStatus.find_by_breastfeeding_status_id(breastfeeding_status['obs_id'])

  value_coded = get_master_def_id(breastfeeding_status['concept_id'], 'concept_name')
  if breastfeeding_status_exist.blank?
    begin
      BreastfeedingStatus.create(
        breastfeeding_status_id: breastfeeding_status['obs_id'],
        concept_id: breastfeeding_status['concept_id'],
        encounter_id: breastfeeding_status['encounter_id'],
        value_coded: value_coded,
        voided: breastfeeding_status['voided'],
        voided_by: breastfeeding_status['voided_by'],
        voided_date: breastfeeding_status['voided_date'],
        void_reason: breastfeeding_status['void_reason'],
        app_date_created: breastfeeding_status['date_created'],
        app_date_updated: breastfeeding_status['date_updated'])

        remove_failed_record('breastfeeding_status', breastfeeding_status['obs_id'].to_i)
    rescue Exception => e
      log_error_records('breastfeeding_status', breastfeeding_status['obs_id'].to_i, e)
    end
  elsif check_latest_record(breastfeeding_status, breastfeeding_status_exist)
    breastfeeding_status_exist.update(
      concept_id: breastfeeding_status['concept_id'], 
      encounter_id: breastfeeding_status['encounter_id'],
      value_coded: value_coded, voided: breastfeeding_status['voided'],
      voided_by: breastfeeding_status['voided_by'],
      voided_date: breastfeeding_status['voided_date'],
      app_date_created: breastfeeding_status['date_created'], 
      app_date_updated: breastfeeding_status['date_updated'])
  end
end
