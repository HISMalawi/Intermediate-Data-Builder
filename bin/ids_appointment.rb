def ids_appointment(rds_appointment)
appointment = Appointment.find_by_appointment_id(rds_appointment['obs_id'])

rds_appointment = handle_commons(rds_appointment)

    if appointment.blank?
      begin
	      appointment 					= Appointment.new
	      appointment.appointment_id	= rds_appointment['obs_id']
	      appointment.encounter_id 		= rds_appointment['encounter_id']
	      appointment.appointment_date 	= rds_appointment['value_datetime'] rescue '1900-01-01'
	      appointment.voided 			= rds_appointment['voided']
	      appointment.voided_by 		= rds_appointment['voided_by']
	      appointment.creator 			= rds_appointment['creator']
	      appointment.voided_date 		= rds_appointment['date_voided']
	      appointment.void_reason 		= rds_appointment['void_reason']
	      appointment.app_date_created 	= rds_appointment['date_created']
	      appointment.app_date_updated 	= rds_appointment['date_changed']
	      appointment.save

        remove_failed_record('appointment', rds_appointment['obs_id'].to_i)

    rescue Exception => e
      log_error_records('appointment', rds_appointment['obs_id'].to_i, e)
    end
    elsif appointment && check_latest_record(rds_appointment, appointment)
      appointment.update(
      encounter_id: rds_appointment['encounter_id'],
      appointment_date: (rds_appointment['value_datetime'] || '1900-01-01'),
      voided: rds_appointment['voided'], 
      voided_by: rds_appointment['voided_by'],
      creator: rds_appointment['creator'], 
      voided_date: rds_appointment['date_voided'],
      void_reason: rds_appointment['void_reason'], 
      app_date_created: rds_appointment['date_created'],
      app_date_updated: rds_appointment['date_changed'])

    end
end