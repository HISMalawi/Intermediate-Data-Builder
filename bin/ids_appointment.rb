def ids_appointment(rds_appointment, failed_records)
puts "processing person_id #{rds_appointment['person_id']}"

    if Appointment.find_by(encounter_id: rds_appointment['encounter_id']).blank?
	      appointment = Appointment.new
	      appointment.encounter_id = rds_appointment['encounter_id']
	      appointment.appointment_date = rds_appointment['value_datetime']
	      appointment.voided = rds_appointment['voided']
	      appointment.voided_by = rds_appointment['voided_by']
	      appointment.creator = rds_appointment['creator']
	      appointment.voided_date = rds_appointment['date_voided']
	      appointment.void_reason = rds_appointment['void_reason']
	      appointment.app_date_created = rds_appointment['date_created']
	      appointment.app_date_updated = rds_appointment['date_changed']
	      appointment.save

	      puts "Successfully populated appointment with record for person #{rds_appointment['person_id']}"
    else
      appointment = Appointment.where(encounter_id: rds_appointment['encounter_id'])
      appointment.update(encounter_id: rds_appointment['encounter_id'], appointment_date: rds_appointment['value_datetime'],
                         voided: rds_appointment['voided'], voided_by: rds_appointment['voided_by'],
                         creator: rds_appointment['creator'], voided_date: rds_appointment['date_voided'],
                         void_reason: rds_appointment['void_reason'], created_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'),
                         updated_at: Date.today.strftime('%Y-%m-%d %H:%M:%S'))

      puts "Successfully updated appointment details with record for person #{rds_appointment['person_id']}"
    end
end