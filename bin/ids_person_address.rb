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

  person_address = handle_commons(person_address)

  puts "Processing Person Address for person_id: #{person_address['person_id']}"

  person_address = "(#{person_address['person_address_id'].to_i}, #{person_address['person_id'].to_i},
                         #{home_district_id.to_i}, 1,  1, #{curent_district_id.to_i},  1,  1,  1,
                          #{person_address['creator'].to_i},  #{person_address['landmark'].to_i},
                          #{person_address['voided']}, #{person_address['voided_by']},
                          #{person_address['date_voided']}, \"#{person_address['void_reason']}\",
                          #{person_address['date_created']},  #{person_address['date_changed']}),".squish

  return person_address
end
  