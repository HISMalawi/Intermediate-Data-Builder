def ids_patient_outcome (rds_outcomes)
    puts "processing person_id #{rds_outcomes['patient_id']}"

    
  outcome = "#{rds_outcomes['patient_id'].to_i},
            #{rds_outcomes['patient_id'].to_i},
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
      outcome.app_date_updated = rds_outcomes['date_changed'] "


     
end