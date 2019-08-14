def ids_prescription(rds_prescription, failed_records)

puts "processing person_id #{rds_prescription['patient_id']}"
    if MedicationPrescription.find_by(medication_prescription_id: rds_prescription['order_id']).blank?
      begin
	      MedicationPrescription.create(medication_prescription_id: rds_prescription['order_id'],
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

	      if failed_records.include?(rds_prescription['obs_id'].to_s)
        	remove_failed_record('Prescription', rds_prescription['obs_id'])
      	  end
      rescue Exception => e
	      File.write('log/app_errors.log', e.message, mode: 'a')
	      log_error_records('Prescription', rds_prescription['obs_id'].to_i)
      end

	      puts "Successfully populated medication prescription details with record for person #{rds_prescription['patient_id']}"
    else
      medication_prescription = MedicationPrescription.find_by(medication_prescription_id: rds_prescription['order_id'])
      medication_prescription.update(drug_id: rds_prescription['drug_inventory_id'],
      								 encounter_id: rds_prescription['encounter_id'],
                                     start_date: rds_prescription['start_date'],
                                     end_date: rds_prescription['auto_expire_date'],
                                     instructions: rds_prescription['instructions'], 
                                     voided: rds_prescription['voided'],
                                     voided_by: rds_prescription['voided_by'], 
                                     voided_date: rds_prescription['date_voided'],
                                     void_reason: rds_prescription['void_reason'], 
                                     created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'),
                                     updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated medication prescription details with record for person #{rds_prescription['patient_id']}"
    end
end