# frozen_string_literal: true

def ids_people(person)
  person['birthdate'].blank? ? dob = "'1900-01-01'" : dob = "'#{person['birthdate'].to_date}'"

  person['death_date'].blank? ? dod = 'NULL' : dod = "'#{person['death_date'].to_date}'"

  person['date_voided'].blank? ? voided_date = 'NULL' : voided_date = "'#{person['date_voided'].strftime('%Y-%m-%d %H:%M:%S')}'"

  person['date_created'].blank? ? app_created_at = 'NULL' : app_created_at = "'#{person['date_created'].strftime('%Y-%m-%d %H:%M:%S')}'"

  person['date_changed'].blank? ? app_updated_at = 'NULL' : app_updated_at = "'#{person['date_changed'].strftime('%Y-%m-%d %H:%M:%S')}'"

  gender = person['gender'] == 'M' ? 1 : 0

  puts "processing person_id #{person['person_id']}"
  
  person = "(#{person['person_id'].to_i}, #{dob}, #{person['birthdate_estimated'].to_i},\
            #{gender.to_i}, #{dod}, #{person['creator']}, '#{person['cause_of_death']}',\
            #{voided_date}, #{person['dead'].to_i},\
            #{person['voided'].to_i}, #{person['voided_by'].to_i}, \
            #{person['void_reason'].to_i}, #{app_created_at}, #{app_updated_at}),".squish
  
  return person 
end
