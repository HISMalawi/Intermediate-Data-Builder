require 'yaml'
require 'damerau-levenshtein'

@rds_db  		=	 YAML.load_file("#{Rails.root}/config/database.yml")['rds']['database']
@last_updated 	=	 YAML.load_file("#{Rails.root}/log/last_update.yml")
@batch_size 	=	 50_000



def get_all_rds_people
	if @last_updated.include?('Person')
		if @last_updated['Person'].blank?
			last_updated = '1900-01-01 00:00:00'
		else
			last_updated = @last_updated['Person']
		end
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



def get_rds_person_name(person_id, voided = 0)
	if @last_updated['PersonName'].blank?
		last_updated = '1900-01-01 00:00:00'
	else
		last_updated = @last_updated['PersonName']
	end

	rds_people = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_name where person_id = #{person_id}
	AND (date_created >= '#{last_updated}'
	OR date_changed >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

QUERY

end

def get_rds_person_addresses(person_id)
	if @last_updated['PersonAddress'].blank?
		last_updated = '1900-01-01 00:00:00'
	else
		last_updated = @last_updated['PersonAddress']
	end

	rds_people = ActiveRecord::Base.connection.select_all <<QUERY
	SELECT * FROM #{@rds_db}.person_address where person_id = #{person_id}
	AND (date_created >= '#{last_updated}'
	OR date_voided  >=  '#{last_updated}');

QUERY

end



def check_for_duplicate(person)	
end

def load_person
	get_all_rds_people.each do |person|
		
		if person['birthdate'].blank? 
			dob = "'1900-01-01'"
		else
			dob = "'#{person['birthdate'].to_date}'"
		end

		if person['death_date'].blank?
		 dod = 'NULL' 
		else 
		 dod = "'#{person['death_date'].to_date}'"
		end
        
		if person['date_voided'].blank? 
		 voided_date = 'NULL' 
		else
		 voided_date = "'#{person['date_voided']}'"
		end

		if person['date_created'].blank?
			app_created_at = 'NULL' 
		else
			app_created_at = "'#{person['date_created'].to_date}'"
		end

		if person['date_changed'].blank?
			app_updated_at = "'#{person['date_created'].to_date}'"
		else
			app_updated_at = "'#{person['date_changed'].to_date}'"
		end

		if person['gender'] == 'M'
			gender = 1
		else
			gender = 0
		end
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
       current_update_date['Person'] = person['date_voided'] || person['date_changed'] || person['date_created']
		   File.open("log/last_update.yml","w") do |file|
			file.write current_update_date.to_yaml
  	end
	end
end




def load_to_ids
	rds_people = get_all_rds_people
	rds_people.each do |person|
		demographics = {}
		demographics[:person] = person
		demographics.merge!(get_rds_person_name(person['person_id']).first)
		demographics.merge!(get_rds_person_addresses(person['person_id']).first) \
		unless get_rds_person_addresses(person['person_id']).first.blank?
	end
	
end



load_person

