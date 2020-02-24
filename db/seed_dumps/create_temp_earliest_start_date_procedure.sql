CREATE PROCEDURE create_temp_earliest_start_date()
DROP TABLE IF EXISTS temp_earliest_start_date;
CREATE TABLE IF NOT EXISTS temp_earliest_start_date (
             patient_id BIGINT PRIMARY KEY,
             date_enrolled DATE NOT NULL,
             earliest_start_date DATETIME,
             birthdate DATE DEFAULT NULL,
             birthdate_estimated BOOLEAN,
             death_date DATE,
             gender VARCHAR(32),
             age_at_initiation INT DEFAULT NULL,
             age_in_days INT DEFAULT NULL
          ) ENGINE=MEMORY;
CREATE INDEX patient_id_index ON temp_earliest_start_date (patient_id);
CREATE INDEX date_enrolled_index ON temp_earliest_start_date (date_enrolled);
CREATE INDEX patient_id__date_enrolled_index ON temp_earliest_start_date (patient_id, date_enrolled);
CREATE INDEX earliest_start_date_index ON temp_earliest_start_date (earliest_start_date);
CREATE INDEX earliest_start_date__date_enrolled_index ON temp_earliest_start_date (earliest_start_date, date_enrolled);

INSERT INTO temp_earliest_start_date
          select
            `p`.`patient_id` AS `patient_id`,
            cast(patient_date_enrolled(`p`.`patient_id`) as date) AS `date_enrolled`,
            date_antiretrovirals_started(`p`.`patient_id`, min(`s`.`start_date`)) AS `earliest_start_date`,
            `pe`.`birthdate`,
            `pe`.`birthdate_estimated`,
            `person`.`death_date` AS `death_date`,
            `pe`.`gender` AS `gender`,
            (select timestampdiff(year, `pe`.`birthdate`, min(`s`.`start_date`))) AS `age_at_initiation`,
            (select timestampdiff(day, `pe`.`birthdate`, min(`s`.`start_date`))) AS `age_in_days`
          from
            ((`patient_program` `p`
            left join `person` `pe` ON ((`pe`.`person_id` = `p`.`patient_id`))
            left join `patient_state` `s` ON ((`p`.`patient_program_id` = `s`.`patient_program_id`)))
            left join `person` ON ((`person`.`person_id` = `p`.`patient_id`)))
          where
            ((`p`.`voided` = 0)
                and (`s`.`voided` = 0)
                and (`p`.`program_id` = 1)
                and (`s`.`state` = 7))
                and (DATE(`s`.`start_date`) >= '1900-01-1 00:00:00')
          group by `p`.`patient_id`
          HAVING date_enrolled IS NOT NULL;