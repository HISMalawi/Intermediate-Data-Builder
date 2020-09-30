
require "damerau-levenshtein"

@percentage_threhold = 85


def main
	count = ActiveRecord::Base.connection.select_all <<~SQL
	  SELECT count(*) count FROM edrs_people;
	SQL

	count = count.first['count'].to_i

	ActiveRecord::Base.connection.select_all <<~SQL
	  CREATE TABLE IF NOT EXISTS edrs_potential_duplicates (edrs_person_id VARCHAR(36), 
	  ids_person_id VARCHAR(36), score INT, PRIMARY KEY(edrs_person_id, ids_person_id));
	SQL

	edrs_people = ActiveRecord::Base.connection.select_all <<~SQL
	  SELECT person_id,first_name_code,last_name_code,concat_ws('',first_name_code, last_name_code, 
	  	left(gender,1), DATE(birthdate), home_village, home_ta, home_district) edrs_pple FROM edrs_people;
	SQL


	edrs_people.each_with_index do |person,i|
		print "Processing #{i+1} / #{count} \r"

		ids_pple = ActiveRecord::Base.connection.select_all <<~SQL
			 	            SELECT
								p2.person_id as ids_person_id, 
								CONCAT_WS('',s.first_name, s.last_name, IF(p2.gender = 1, 'M', 'F'), 
								DATE(p2.birthdate), pa.home_village_id, 
								pa.home_traditional_authority_id, pa.home_district_id) ids_concatinated
							FROM
								people p2
							JOIN person_addresses pa on
								p2.person_id = pa.person_id
							JOIN soundexes s on
								s.person_id = p2.person_id
							WHERE
								s.first_name = \"#{person['first_name_code']}\"
								AND s.last_name = \"#{person['last_name_code']}\"
			 SQL

	     ids_pple.each do |ids_person|

	     	score = calculate_similarity_score(person['edrs_pple'].gsub(/[[:space:]]/, ''),ids_person['ids_concatinated'].gsub(/[[:space:]]/, ''))
	        
	        if score >= @percentage_threhold       

				ActiveRecord::Base.connection.execute <<~SQL
				  INSERT IGNORE INTO edrs_potential_duplicates VALUES (\"#{person['person_id'].to_s}\",\"#{ids_person['ids_person_id']}\",#{score.to_i});
			    SQL
			end
		 end
	end
end

def calculate_similarity_score(string_A,string_B)
   	#Calulating % Similarity using the formula %RSD = (SD/max_ed)%
   	#Where SD = Max(length(A),Length(B)) - Edit Distance

   	ed = DamerauLevenshtein.distance(string_A,string_B)

    if string_A.size >= string_B.size
    	max_ed = string_A.size
    else 
    	max_ed = string_B.size
    end

    sd = max_ed - ed

    score = (sd/max_ed.to_f) * 100
end

main