# frozen_string_literal: true

def ids_person_name(person_name)
   puts "processing person_name for person_id #{person_name['person_id']}"

  person_name['date_voided'].blank? ? voided_date = 'NULL' : voided_date = "'#{person_name['date_voided'].strftime('%Y-%m-%d %H:%M:%S')}'"

  person_name['date_created'].blank? ? app_created_at = 'NULL' : app_created_at = "'#{person_name['date_created'].strftime('%Y-%m-%d %H:%M:%S')}'"

  person_name['date_changed'].blank? ? app_updated_at = 'NULL' : app_updated_at = "'#{person_name['date_changed'].strftime('%Y-%m-%d %H:%M:%S')}'"
  
   person_name = "(#{person_name['person_name_id'].to_i}, #{person_name['person_id'].to_i},\
                   \"#{person_name['given_name']}\", \"#{person_name['family_name']}\",\
                   \"#{person_name['middle_name']}\", \"#{person_name['maiden_name']}\",\
                   #{person_name['creator'].to_i}, #{person_name['voided'].to_i}, #{person_name['voided_by'].to_i},\
                   '#{person_name['void_reason']}', #{app_created_at}, #{app_updated_at}),".squish
  
  return person_name 
end
