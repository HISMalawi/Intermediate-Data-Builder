def ids_breastfeeding_status(breastfeeding_status)
  puts "Updating Breastfeeding Status for person_id: #{breastfeeding_status['person_id']}"
  breastfeeding_status_exist = BreastfeedingStatus.find_by(concept_id: breastfeeding_status['concept_id'],
                                                           encounter_id: breastfeeding_status['encounter_id'])

  value_coded = get_master_def_id(breastfeeding_status['concept_id'], 'concept_name')
  if breastfeeding_status_exist.blank?
    BreastfeedingStatus.create(concept_id: breastfeeding_status['concept_id'], encounter_id: breastfeeding_status['encounter_id'],
                               value_coded: value_coded, voided: breastfeeding_status['voided'], voided_by: breastfeeding_status['voided_by'],
                               voided_date: breastfeeding_status['voided_date'], void_reason: breastfeeding_status['void_reason'], app_date_created: breastfeeding_status['date_created'],
                               app_date_updated: breastfeeding_status['date_updated'])
  elsif 
    breastfeeding_status_exist.update(concept_id: breastfeeding_status['concept_id'], encounter_id: breastfeeding_status['encounter_id'],
                                      value_coded: value_coded, voided: breastfeeding_status['voided'],
                                      voided_by: breastfeeding_status['voided_by'], voided_date: breastfeeding_status['voided_date'],
                                      app_date_created: breastfeeding_status['date_created'], app_date_updated: breastfeeding_status['date_updated'])
  end
  update_last_update('BreastfeedingStatus', breastfeeding_status['updated_at'])
end
