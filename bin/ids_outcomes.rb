def ids_outcomes(rds_outcomes)
      if Outcome.find_by(person_id: rds_outcomes['patient_id'],
                         concept_id: rds_outcomes['concept_id']).blank?
        #begin
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
          outcome.voided = rds_outcomes['retired']
          outcome.voided_by = rds_outcomes['changed_by']
          outcome.voided_date = rds_outcomes['date_voided'] rescue nil
          outcome.void_reason = rds_outcomes['void_reason'] rescue nil
          outcome.app_date_created = rds_outcomes['date_created']
          outcome.app_date_updated = rds_outcomes['date_changed']
          outcome.save

        #     remove_failed_record('outcomes', outcome['patient_program_id'].to_i)
        # rescue Exception => e
        #   log_error_records('outcomes', outcome['patient_program_id'].to_i, e)
        # end
    else
      outcome = Outcome.find_by(person_id: rds_outcomes['patient_id'],
                                concept_id: rds_outcomes['concept_id'])
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
      outcome.update(voided: (rds_outcomes['voided'] || 0),
                     voided_by: rds_outcomes['voided_by'],
                     voided_date: rds_outcomes['date_voided'],
                     void_reason: rds_outcomes['void_reason'],
                     app_date_created: rds_outcomes['date_created'],
                     app_date_updated: rds_outcomes['date_changed'])

    end
end