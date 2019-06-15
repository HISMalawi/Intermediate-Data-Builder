# frozen_string_literal: true

require 'yaml'
require 'damerau-levenshtein'

@rds_db = YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']
File.open("#{Rails.root}/log/last_update.yml", 'w') { |file| file.puts 'Person: 1900-01-01 00:00:00' } # Create a tracking file if it does not exist
@last_updated = YAML.load_file("#{Rails.root}/log/last_update.yml")
@batch_size = 50_000
@threshold = 85

def get_all_rds_people
  if @last_updated.include?('Person')
    @last_updated['Person'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['Person']
  else
    last_updated = '1900-01-01 00:00:00'
  end

  rds_people = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person where date_created >= '#{last_updated}'
	OR date_changed >= '#{last_updated}'
	OR date_voided  >= '#{last_updated}'
	AND person_id NOT IN (SELECT person_id FROM #{@rds_db}.users)
  ORDER BY date_created, date_changed, date_voided;

QUERY
end

def get_rds_person_name(person_id)
  @last_updated['PersonName'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['PersonName']
  person_name = []
  rds_person_name = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_name where person_id = #{person_id}
	AND (date_created >= '#{last_updated}'
	OR date_changed >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

QUERY
  rds_person_name.each { |name| person_name << name }
end

def get_rds_person_addresses(person_id)
  @last_updated['PersonAddress'].blank? ? last_updated = '1900-01-01 00:00:00' : last_updated = @last_updated['PersonAddress']
  person_address = []
  rds_address = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_address where person_id = #{person_id}
	AND (date_created >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

QUERY

  rds_address.each { |address| person_address << address }
end

def find_duplicates(subject, subject_person_id)
  duplicates = ActiveRecord::Base.connection.select_all <<QUERY
			SELECT person_id, ROUND(CAST((((length("#{subject}") - levenshtein(person_de_duplicator,"#{subject}",2))/ length("#{subject}")) * 100) AS DECIMAL),2)
 as score FROM de_duplicators WHERE person_id != #{subject_person_id};
QUERY
end

def process_duplicates(duplicates, duplicate_id)
  duplicates.each do |duplicate|
    if duplicate['score'].to_f >= @threshold
      # save to duplicate_statuses
      PotentialDuplicate.create(person_id_a: duplicate_id, person_id_b: duplicate['person_id'], score: duplicate['score'].to_f)
    end
  end
end

def check_for_duplicate(demographics)
  # find matching text in de_duplicator table
  subject = ''
  begin
    subject << demographics[:person_names][0]['given_name']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_names][0]['family_name']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person]['gender']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person]['birthdate'].strftime('%Y-%m-%d').gsub('-', '')
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['address2']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['county_district']
  rescue StandardError
    nil
  end
  begin
    subject << demographics[:person_address][0]['neighborhood_cell']
  rescue StandardError
    nil
  end

  duplicates = find_duplicates(subject, demographics[:person]['person_id'])

  person_present = DeDuplicator.find_by(person_id: demographics[:person]['person_id'])
  if person_present
    puts 'person_present'
    person_present.update(person_de_duplicator: subject)
  else
    DeDuplicator.create(person_id: demographics[:person]['person_id'], person_de_duplicator: subject)
    begin
      puts duplicates.first['score'].to_f.inspect
    rescue StandardError
      nil
    end
  end
  process_duplicates(duplicates, demographics[:person]['person_id']) unless duplicates.blank?
end

def load_person
  get_all_rds_people.each do |person|
    person['birthdate'].blank? ? dob = "'1900-01-01'" : dob = "'#{person['birthdate'].to_date}'"

    person['death_date'].blank? ? dod = 'NULL' : dod = "'#{person['death_date'].to_date}'"

    person['date_voided'].blank? ? voided_date = 'NULL' : voided_date = "'#{person['date_voided'].strftime('%Y-%m-%d %H:%M:%S')}'"

    person['date_created'].blank? ? app_created_at = 'NULL' : app_created_at = "'#{person['date_created'].strftime('%Y-%m-%d %H:%M:%S')}'"

    person['date_changed'].blank? ? app_updated_at = 'NULL' : app_updated_at = "'#{person['date_changed'].strftime('%Y-%m-%d %H:%M:%S')}'"

    gender = person['gender'] == 'M' ? 1 : 0

    puts "processiong person_id #{person['person_id']}"

    if Person.find_by(person_id: person['person_id']).blank?
      ActiveRecord::Base.connection.execute <<QUERY
			INSERT INTO people (person_id,birthdate,birthdate_est, \
									person_type_id, gender, death_date,  \
									cause_of_death, dead, voided, \
									voided_by,voided_date,void_reason,app_date_created, \
									app_date_updated,created_at,updated_at ) \
									values  (#{person['person_id'].to_i}, \
							  				#{dob}, \
							  				#{person['birthdate_estimated'].to_i}, \
							  				1, \
							   				#{gender.to_i}, \
							   				#{dod}, \
							   				'#{person['cause_of_death']}', \
							   				#{person['dead'].to_i}, \
							  				#{person['voided'].to_i}, \
							 				  #{person['voided_by'].to_i}, \
							 				 #{voided_date}, \
							  				#{person['void_reason'].to_i}, \
							  				#{app_created_at}, \
							  				#{app_updated_at}, \
							  				now(), \
							     			now());
QUERY
    else
      ActiveRecord::Base.connection.execute <<QUERY
			UPDATE people SET person_id				= 	#{person['person_id'].to_i}, \
							  birthdate				=   #{dob}, \
							  birthdate_est 		=	#{person['birthdate_estimated'].to_i}, \
							  person_type_id		=	1, \
							  gender 				= 	#{gender.to_i}, \
							  death_date 			= 	#{dod}, \
							  cause_of_death		=	'#{person['cause_of_death']}', \
							  dead 					=	#{person['dead'].to_i}, \
							  voided 				=	#{person['voided'].to_i}, \
							  voided_by 			= 	#{person['voided_by'].to_i}, \
							  voided_date			=	#{voided_date}, \
							  void_reason 			=	1, \
							  app_date_created		=	#{app_created_at}, \
							  app_date_updated		=	#{app_updated_at}, \
							  updated_at			=    now()  \
							  where person_id 		= 	 #{person['person_id']};
QUERY
    end
    current_update_date = {}
    current_update_date['Person'] = person['date_created'].strftime('%Y-%m-%d %H:%M:%S')
    File.open('log/last_update.yml', 'w') do |file|
      file.write current_update_date.to_yaml
    end
  end
end

def load_to_ids
  rds_people = get_all_rds_people
  rds_people.each do |person|
    demographics = {}
    demographics = { "person": person }
    demographics.update("person_names": get_rds_person_name(person['person_id']))
    demographics.update("person_address": get_rds_person_addresses(person['person_id']))

    check_for_duplicate(demographics)
  end
end

load_person
load_to_ids
