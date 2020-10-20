
start_date = '2000-01-01'

if Time.now.end_of_quarter > Time.now
   end_date = Time.now.beginning_of_quarter
elsif Time.now.end_of_quarter == Time.now
   end_date = Time.now
end

ActiveRecord::Base.connection.execute <<~SQL
  DROP TABLE IF EXISTS pdi_regimen;
SQL

ActiveRecord::Base.connection.execute <<~SQL
  CREATE TABLE pbi_regimen (
	id bigint unsigned auto_increment primary key,
	person_id bigint,
	gender CHAR(1),
	birthdate date,
	last_visit datetime,
	regimen varchar(50),
	site_name varchar(255),
	district varchar(255), 
	region varchar(50),
	created_at datetime);
SQL

ActiveRecord::Base.connection.execute <<~SQL
  SET sql_mode='';
SQL

while start_date.to_date != end_date.to_date do
	puts "Generating current Regimen for Period #{start_date} to #{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}"

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
			medication_dispensations md
		JOIN (
			SELECT
				mp3.medication_prescription_id, mp3.start_date, mp3.end_date, mp3.encounter_id
			FROM
				(
				SELECT
					mp2.medication_prescription_id, e1.person_id, mp2.start_date, mp2.end_date, mp2.encounter_id
				FROM
					medication_prescriptions mp2
				JOIN encounters e1 ON
					mp2.encounter_id = e1.encounter_id) mp3
			JOIN (
				SELECT
					max(mp1.medication_prescription_id) med_presc_id
				FROM
					medication_prescriptions mp1
				JOIN encounters e ON
					mp1.encounter_id = e.encounter_id
				JOIN medication_dispensations md ON
					mp1.medication_prescription_id = md.medication_prescription_id
				WHERE
					date(start_date) BETWEEN '#{start_date.to_date.beginning_of_quarter}' AND 
					'#{start_date.to_date.end_of_quarter}'
					AND md.quantity > 0
					AND md.voided = 0
					AND mp1.voided = 0
					AND e.voided = 0
					AND mp1.drug_id in (
					select
						master_definition_id
					from
						master_definitions md2
					JOIN arv_drugs av ON
						md2.openmrs_metadata_id = av.drug_id
					WHERE
						md2.openmrs_entity_name = 'drug')
				GROUP BY
					person_id) mp4 ON
				mp3.medication_prescription_id = mp4.med_presc_id
			WHERE
				TIMESTAMPDIFF(day,
				end_date,
				'#{(start_date.to_date.end_of_quarter.to_s + ' ' + '23:59:59')}' ) <= 58) mp ON
			md.medication_prescription_id = mp.medication_prescription_id
		JOIN encounters e ON
			mp.encounter_id = e.encounter_id
		join medication_prescription_has_medication_regimen mphr on
			e.encounter_id = mphr.medication_prescription_encounter_id
		join medication_regimen mr on
			mphr.medication_regimen_id = mr.medication_regimen_id
		join people p on
			e.person_id = p.person_id
		join sites s on
			right(e.encounter_id,
			5) = s.site_id
		JOIN (
			SELECT
				o2.person_id, o2.concept_id, o2.outcome_source, o2.outcome_id
			FROM
				outcomes o2
			JOIN (
				SELECT
					o.person_id, max(outcome_id) max_outcome_id, o.start_date
				FROM
					outcomes o
				JOIN (
					SELECT
						person_id, max(start_date) max_start_date
					FROM
						outcomes o5
					WHERE
						o5.voided = 0
						AND date(o5.start_date) <= '#{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}'
						AND o5.outcome_source = 1
					GROUP by
						person_id) o6 ON
					o.person_id = o6.person_id
					AND o.start_date = o6.max_start_date
				WHERE
					voided = 0
					AND date(o.start_date) <= '#{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}'
					AND o.outcome_source = 1
				GROUP BY
					start_date, o.person_id ) o3 ON
				o2.outcome_id = o3.max_outcome_id
				AND date(o2.start_date) <= '#{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}'
				AND concept_id IN (2400,
				2401,
				3106,
				3107,
				20805,
				2895)) o4 ON
			p.person_id = o4.person_id
		JOIN master_definitions mad ON
			e.program_id = mad.master_definition_id
			AND mad.openmrs_entity_name = 'program'
		join locations l on
			s.parent_district = l.location_id
		join master_definitions mdf on
			l.parent_location = mdf.openmrs_metadata_id
			and mdf.openmrs_entity_name = 'district_region_mapping'
		WHERE
			mad.master_definition_id = 1
			and DATE(mp.start_date) between '#{start_date.to_date.beginning_of_quarter}' AND '#{start_date.to_date.end_of_quarter.strftime('%Y-%m-%d')}'
			AND md.voided = '0'
			-- and mp.voided = '0'
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
		group by
			e.person_id;
    SQL
    start_date = (start_date.to_date + 3.months).strftime('%Y-%m-%d')
end

