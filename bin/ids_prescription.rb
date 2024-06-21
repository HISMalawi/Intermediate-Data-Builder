def ids_prescription(rds_prescription)
<<<<<<< HEAD

puts "processing Prescription for person_id #{rds_prescription['patient_id']}"

    prescription = MedicationPrescription.find_by_medication_prescription_id(rds_prescription['order_id'])

=======
    prescription = MedicationPrescription.find_by_medication_prescription_id(rds_prescription['order_id'])

    rds_prescription = handle_commons(rds_prescription)

>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
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
<<<<<<< HEAD
	        void_reason: rds_prescription['void_reason'], 
=======
	        void_reason: rds_prescription['void_reason'],
          creator: rds_prescription['creator'],
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
	        app_date_created: rds_prescription['date_created'],
	        app_date_updated: rds_prescription['date_changed'])

        	remove_failed_record('prescription', rds_prescription['order_id'].to_i)
      rescue Exception => e
	      log_error_records('prescription', rds_prescription['order_id'].to_i, e)
      end

<<<<<<< HEAD
	      puts "Successfully populated medication prescription details with record for person #{rds_prescription['patient_id']}"
=======
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
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
<<<<<<< HEAD
        app_date_created: rds_prescription['date_created'],
        app_date_updated: rds_prescription['date_changed']
        )

      puts "Successfully updated medication prescription details with record for person #{rds_prescription['patient_id']}"
    end
  update_last_update('Prescription', rds_prescription['updated_at'])
=======
        creator: rds_prescription['creator'],
        app_date_created: rds_prescription['date_created'],
        app_date_updated: rds_prescription['date_changed']
        )
    end
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
end
