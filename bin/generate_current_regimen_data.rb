
start_date = '2000-01-01'

def create_mp3_tmp_table
	ActiveRecord::Base.connection.execute <<~SQL
       DROP TEMPORARY TABLE IF EXISTS mp3; 
    SQL
    
    ActiveRecord::Base.connection.execute <<~SQL
       CREATE TEMPORARY TABLE mp3 AS SELECT
		mp2.medication_prescription_id, e1.person_id, mp2.start_date, mp2.end_date, mp2.encounter_id
	FROM
		medication_prescriptions mp2
	JOIN encounters e1 ON
		mp2.encounter_id = e1.encounter_id;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
      ALTER TABLE mp3 add index(medication_prescription_id);
    SQL
end

def create_tmp_drug_table
	ActiveRecord::Base.connection.execute <<~SQL
	   DROP TEMPORARY TABLE IF EXISTS drug;
	SQL

	ActiveRecord::Base.connection.execute <<~SQL
	 CREATE TEMPORARY TABLE drug AS  select
							master_definition_id
						from
							master_definitions md2
						JOIN arv_drugs av ON
							md2.openmrs_metadata_id = av.drug_id
						WHERE
							md2.openmrs_entity_name = 'drug';
	SQL

	ActiveRecord::Base.connection.execute <<~SQL
	  ALTER TABLE drug add index(master_definition_id);
	SQL

end


def create_tmp_mp4_table(start_date)
	ActiveRecord::Base.connection.execute <<~SQL
       DROP TEMPORARY TABLE IF EXISTS mp4; 
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
       CREATE TEMPORARY TABLE mp4 AS SELECT
						max(mp1.medication_prescription_id) med_presc_id
					FROM
						medication_prescriptions mp1
					JOIN encounters e ON
						mp1.encounter_id = e.encounter_id
					JOIN medication_dispensations md ON
						mp1.medication_prescription_id = md.medication_prescription_id
					JOIN drug 
					    ON mp1.drug_id = drug.master_definition_id
					WHERE
						date(mp1.start_date) BETWEEN '#{start_date.to_date.beginning_of_quarter}' AND 
						'#{start_date.to_date.end_of_quarter}'
						AND md.quantity > 0
						AND md.voided = 0
						AND mp1.voided = 0
						AND e.voided = 0
					GROUP BY
						person_id;
    SQL
  
    ActiveRecord::Base.connection.execute <<~SQL
       ALTER TABLE mp4 add index(med_presc_id);
    SQL
end


def create_tmp_o6_table(start_date)
	ActiveRecord::Base.connection.execute <<~SQL
      DROP TEMPORARY  TABLE IF EXISTS o6;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
       CREATE TEMPORARY TABLE o6 AS SELECT
							person_id, max(start_date) max_start_date
						FROM
							outcomes o5
						WHERE
							o5.voided = 0
							AND date(o5.start_date) <= '#{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}'
							AND o5.outcome_source = 1
						GROUP by
							person_id;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
       ALTER TABLE o6 add index(max_start_date,person_id);
    SQL
end


def create_tmp_o3_table(start_date)
	ActiveRecord::Base.connection.execute <<~SQL
      DROP TEMPORARY TABLE  IF EXISTS o3;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
       CREATE TEMPORARY  TABLE o3 AS SELECT
						o.person_id, max(outcome_id) max_outcome_id, o.start_date
					FROM
						outcomes o
					JOIN o6 ON
						o.person_id = o6.person_id
						AND o.start_date = o6.max_start_date
					WHERE
						voided = 0
						AND date(o.start_date) <= '#{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}'
						AND o.outcome_source = 1
					GROUP BY
						start_date, o.person_id;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
       ALTER TABLE o3 add index(max_outcome_id);
    SQL
end

def create_tmp_o4_table(start_date)
	ActiveRecord::Base.connection.execute <<~SQL
      DROP TEMPORARY TABLE  IF EXISTS o4;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
       CREATE TEMPORARY TABLE o4 AS SELECT
					o2.person_id, o2.concept_id, o2.outcome_source, o2.outcome_id
				FROM
					outcomes o2
				JOIN  o3 ON
					o2.outcome_id = o3.max_outcome_id
					AND date(o2.start_date) <= '#{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}'
					AND concept_id IN (2400,
					2401,
					3106,
					3107,
					20805,
					2895);
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
       ALTER TABLE o4 add index(person_id,concept_id,outcome_source);
    SQL
end


def create_tmp_mp_table(start_date)

	end_date = start_date.to_date.end_of_quarter.to_s + ' ' + '23:59:59'

	ActiveRecord::Base.connection.execute <<~SQL
      DROP TEMPORARY TABLE IF EXISTS mp;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL
       CREATE TEMPORARY TABLE mp AS SELECT
					mp3.medication_prescription_id, mp3.start_date, mp3.end_date, mp3.encounter_id
				FROM
					 mp3
				JOIN  mp4 ON
					mp3.medication_prescription_id = mp4.med_presc_id
				WHERE
					TIMESTAMPDIFF(day,
					end_date,
					'#{end_date}') <= 58;
    SQL
    
     unless ActiveRecord::Base.connection.execute("SHOW index FROM medication_dispensations WHERE Key_name = 'medication_prescription_id';")
        ActiveRecord::Base.connection.execute <<~SQL
	       ALTER TABLE medication_dispensations ADD INDEX(medication_prescription_id);
	    SQL
	 end

    ActiveRecord::Base.connection.execute <<~SQL
       ALTER TABLE mp add index(encounter_id);
    SQL
    
    unless ActiveRecord::Base.connection.execute("SHOW index FROM master_definitions WHERE Key_name = 'openmrs_metadata_id';")
	    ActiveRecord::Base.connection.execute <<~SQL
	       ALTER TABLE master_definitions add index(openmrs_metadata_id);
	    SQL
	 end
    unless ActiveRecord::Base.connection.execute("SHOW index FROM locations WHERE Key_name = 'openmrs_metadata_id';")
	    ActiveRecord::Base.connection.execute <<~SQL
	       ALTER TABLE locations add index(parent_location);
	    SQL
	end
end


def populate_regimen(start_date) 
       #Disable Full group by
  	   ActiveRecord::Base.connection.execute <<~SQL
          SET sql_mode='';
       SQL

       create_mp3_tmp_table
       create_tmp_drug_table
       create_tmp_mp4_table(start_date)
       create_tmp_o6_table(start_date)
       create_tmp_o3_table(start_date)
       create_tmp_o4_table(start_date)
       create_tmp_mp_table(start_date)
       

	   ActiveRecord::Base.connection.execute <<~SQL
		INSERT INTO pbi_regimen SELECT
			    NULL,
				e.person_id,
				if(p.gender = '1',
				'M',
				'F') as gender,
				p.birthdate,
				max(e.visit_date) as last_visit,
				mr.regimen,
				s.site_name,
				l.name AS district, 
				mdf.definition AS region,
				now()
			FROM
				mp 
			JOIN medication_dispensations md ON
				mp.medication_prescription_id = md.medication_prescription_id
			JOIN encounters e ON
				mp.encounter_id = e.encounter_id
			JOIN medication_prescription_has_medication_regimen mphr on
				e.encounter_id = mphr.medication_prescription_encounter_id
			JOIN medication_regimen mr ON
				mphr.medication_regimen_id = mr.medication_regimen_id
			JOIN people p ON
				e.person_id = p.person_id
			JOIN sites s ON
				right(e.encounter_id,
				5) = s.site_id
			JOIN o4 ON
				p.person_id = o4.person_id
			JOIN master_definitions mad ON
				e.program_id = mad.master_definition_id
				AND mad.openmrs_entity_name = 'program'
			JOIN locations l on
				s.parent_district = l.location_id
			JOIN master_definitions mdf on
				l.parent_location = mdf.openmrs_metadata_id
			AND mdf.openmrs_entity_name = 'district_region_mapping'
			WHERE
				mad.master_definition_id = 1
				AND DATE(mp.start_date) BETWEEN '#{start_date.to_date.beginning_of_quarter}' 
				AND '#{start_date.to_date.end_of_quarter}'
				AND md.voided = '0'
				 -- AND mp.voided = '0'
				AND e.voided = '0'
				AND mphr.voided = '0'
				AND mr.voided = '0'
				AND p.voided = '0'
				AND s.voided = '0'
				AND o4.outcome_source = 1
				AND o4.concept_id IN (2400,
				2401,
				3106,
				3107,
				20805,
				2895)
			GROUP BY
				e.person_id LOCK IN SHARE MODE;
	    SQL
end

if Time.now.end_of_quarter > Time.now
   end_date = Time.now.beginning_of_quarter
elsif Time.now.end_of_quarter == Time.now
   end_date = Time.now
end



ActiveRecord::Base.connection.execute <<~SQL
  DROP TABLE IF EXISTS pbi_regimen;
SQL

sql = "CREATE TABLE pbi_regimen (
		id bigint unsigned auto_increment primary key,
		person_id bigint,
		gender CHAR(1),
		birthdate date,
		last_visit datetime,
		regimen varchar(50),
		site_name varchar(255),
		district varchar(255), 
		region varchar(50),
		created_at datetime);"

ActiveRecord::Base.connection.execute <<~SQL
  #{sql}
SQL

quarters = []
while start_date.to_date != end_date.to_date do
	puts "Generating current Regimen for Period #{start_date} to #{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}"
    populate_regimen(start_date)
    start_date = (start_date.to_date + 3.months).strftime('%Y-%m-%d')
end
