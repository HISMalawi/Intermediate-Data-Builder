def grouped_address(person_address)
  grouped_address = categorize_address(person_address)
  home_district_id = begin
    get_district_id(grouped_address['home_address']['home_district'])
  rescue StandardError
    get_district_id('other')
  end
  curent_district_id = begin
    get_district_id(grouped_address['current_address']['current_district'])
  rescue StandardError
    get_district_id('other')
  end

  puts "Updating Person Address for person_id: #{person_address['person_id']}"

  person_address_exist = PersonAddress.find_by(person_address_id: person_address['person_address_id'])

  if person_address_exist.blank?
    begin
      PersonAddress.create(
        person_address_id: person_address['person_address_id'],
        person_id: person_address['person_id'],
        home_district_id: home_district_id,
        home_traditional_authority_id: 1,
        home_village_id: 1, country_id: 1,
        current_district_id: curent_district_id,
        current_traditional_authority_id: 1, 
        current_village_id: 1, country_id: 1,
        creator: person_address['creator'],
        landmark: person_address['landmark'],
        app_date_created: person_address['date_created'], 
        app_date_updated: person_address['date_changed'])

        remove_failed_record('person_address', person_address['person_address_id'])
       
    rescue Exception => e
      log_error_records('person_address', person_address['person_address_id'].to_i, e)
    end
  elsif ((person_address['date_changed'].strftime('%Y-%m-%d %H:%M:%S') rescue nil) ||
        person_address['date_created'].strftime('%Y-%m-%d %H:%M:%S')) >
      (person_address_exist.app_date_updated.strftime('%Y-%m-%d %H:%M:%S') rescue 'NULL')
    person_address_exist.update(
      home_district_id: home_district_id,
      home_traditional_authority_id: 1,
      home_village_id: 1, country_id: 1,
      current_district_id: curent_district_id,
      current_traditional_authority_id: 1,
      current_village_id: 1, country_id: 1,
      creator: person_address['creator'],
      landmark: person_address['landmark'],
      app_date_created: person_address['date_created'],
      app_date_updated: person_address['date_changed']
      )  
  end
  update_last_update('PersonAddress', person_address['updated_at'])
end