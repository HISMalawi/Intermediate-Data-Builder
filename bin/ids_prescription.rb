def ids_prescription(rds_prescription)

    prescription = MedicationPrescription.find_by_medication_prescription_id(rds_prescription['order_id'])

    if prescription.blank?
      begin
	      MedicationPrescription.create(
          medication_prescription_id: rds_prescription['order_id'],
	      	drug_id: rds_prescription['drug_inventory_id'],
	        encounter_id: rds_prescription['encounter_id'],
	        start_date: rds_prescription['start_date'], 
	        end_date: rds_prescription['auto_expire_date'],
	        instructions: rds_prescription['instructions'], 
	        voided: rds_prescription['voided'],
	        voided_by: rds_prescription['voided_by'], 
	        voided_date: rds_prescription['date_voided'],
	        void_reason: rds_prescription['void_reason'], 
	        app_date_created: rds_prescription['date_created'],
	        app_date_updated: rds_prescription['date_changed'])

        	remove_failed_record('prescription', rds_prescription['order_id'].to_i)
      rescue Exception => e
	      log_error_records('prescription', rds_prescription['order_id'].to_i, e)
      end

    elsif check_latest_record(rds_prescription, prescription)
      medication_prescription.update(
        drug_id: rds_prescription['drug_inventory_id'],
      	encounter_id: rds_prescription['encounter_id'],
        start_date: rds_prescription['start_date'],
        end_date: rds_prescription['auto_expire_date'],
        instructions: rds_prescription['instructions'], 
        voided: rds_prescription['voided'],
        voided_by: rds_prescription['voided_by'], 
        voided_date: rds_prescription['date_voided'],
        void_reason: rds_prescription['void_reason'], 
        app_date_created: rds_prescription['date_created'],
        app_date_updated: rds_prescription['date_changed']
        )
    end
end
