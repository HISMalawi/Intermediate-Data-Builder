def populate_hiv_staging_info
  last_updated = get_last_updated('StagingInfo')


  update_last_update('StagingInfo', lab_order['updated_at'])

end