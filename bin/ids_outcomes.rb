def ids_outcomes(outcome)
  puts "processing Outcomes for person_id #{rds_outcomes['patient_id']}"

      if Outcome.find_by(person_id: rds_outcomes['patient_id']).blank?
        begin
          outcome = Outcome.new
          outcome.person_id = rds_outcomes['patient_id']
          outcome.concept_id = rds_outcomes['concept_id']
          outcome.outcome_reason = begin
            MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['concept_id']).master_definition_id
                                   rescue StandardError
                                     nil
          end
          outcome.outcome_source = begin
            MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['program_id']).master_definition_id
                                   rescue StandardError
                                     nil
          end
          outcome.voided = rds_outcomes['voided']
          outcome.voided_by = rds_outcomes['voided_by']
          outcome.voided_date = rds_outcomes['date_voided']
          outcome.void_reason = rds_outcomes['void_reason']
          outcome.app_date_created = rds_outcomes['date_created']
          outcome.app_date_updated = rds_outcomes['date_changed']
          outcome.save

          puts "Successfully populated Outcome with record for person #{rds_outcomes['patient_id']}"
            remove_failed_record('outcomes', outcome['patient_program_id'].to_i)
        rescue Exception => e
          log_error_records('outcomes', outcome['patient_program_id'].to_i, e)
        end
    else
      outcome = Outcome.where(person_id: rds_outcomes['patient_id'])
      outcome.update(person_id: rds_outcomes['patient_id'])
      outcome.update(concept_id: rds_outcomes['concept_id'])
      begin
        outcome.update(outcome_reason: MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['concept_id']).master_definition_id)
      rescue StandardError
        nil
      end
      begin
        outcome.update(outcome_source: MasterDefinition.find_by(openmrs_metadata_id: rds_outcomes['program_id']).master_definition_id)
      rescue StandardError
        nil
      end
      outcome.update(voided: rds_outcomes['voided'])
      outcome.update(voided_by: rds_outcomes['voided_by'])
      outcome.update(voided_date: rds_outcomes['date_voided'])
      outcome.update(void_reason: rds_outcomes['void_reason'])
      outcome.update(created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))
      outcome.update(updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated outcome details with record for person #{rds_outcomes['patient_id']}"
    end
end