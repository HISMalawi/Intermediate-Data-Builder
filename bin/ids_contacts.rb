    

def ids_contact_details(contacts)

  puts "processing person_id #{contacts['person_id']}"

  contacts = handle_commons(contacts)

  person = "(#{contacts['person_id'].to_i},
           '#{contacts['home_phone_number']}',
           '#{contacts['cell_phone_number']}',
           '#{contacts['work_phone_number']}',
           NULL,
           #{contacts['creator'].to_i},
           #{contacts['voided'].to_i},
           #{contacts['voided_by'].to_i},
           NULL,
           '#{contacts['void_reason']}',
           #{contacts['date_created']},
           #{contacts['date_changed']}),"

  return person
end