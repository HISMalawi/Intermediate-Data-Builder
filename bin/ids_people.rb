# frozen_string_literal: true

def ids_people(person)
  person['birthdate'].blank? ? dob = "'1900-01-01'" : dob = "'#{person['birthdate'].to_date}'"

  person['death_date'].blank? ? dod = 'NULL' : dod = "'#{person['death_date'].to_date}'"

  person['date_voided'].blank? ? voided_date = 'NULL' : voided_date = "'#{person['date_voided'].strftime('%Y-%m-%d %H:%M:%S')}'"

  person['date_created'].blank? ? app_created_at = 'NULL' : app_created_at = "'#{person['date_created'].strftime('%Y-%m-%d %H:%M:%S')}'"

  person['date_changed'].blank? ? app_updated_at = 'NULL' : app_updated_at = "'#{person['date_changed'].strftime('%Y-%m-%d %H:%M:%S')}'"

  gender = person['gender'] == 'M' ? 1 : 0

  puts "processing person_id #{person['person_id']}"

  person_exits = Person.find_by(person_id: person['person_id'])

  if person_exits.blank?
    Person.create(person_id: person['person_id'].to_i, birthdate: dob, birthdate_est: person['birthdate_estimated'].to_i,
                  gender: gender.to_i, death_date: dod, cause_of_death: person['cause_of_death'], dead: person['dead'].to_i,
                  voided: person['voided'].to_i, voided_by: person['voided_by'].to_i, voided_date: voided_date,
                  void_reason: person['void_reason'].to_i, app_date_created: app_created_at, app_date_updated: app_updated_at)
  else
    person_exits.update(birthdate: dob, birthdate_est: person['birthdate_estimated'].to_i,
                        gender: gender.to_i, death_date: dod, cause_of_death: person['cause_of_death'], dead: person['dead'].to_i,
                        voided: person['voided'].to_i, voided_by: person['voided_by'].to_i, voided_date: voided_date,
                        void_reason: person['void_reason'].to_i, app_date_created: app_created_at, app_date_updated: app_updated_at) if app_updated_at > person_exits.app_updated_at

    puts 'Updating'
  end
  update_last_update('Person', person['updated_at'])
end
