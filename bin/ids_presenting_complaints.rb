# frozen_string_literal: true

def ids_presenting_complaints(presenting_complaint)
  
  puts "processing Complaints for person ID #{presenting_complaint['person_id']}"

  ids_presenting_complaints = PresentingComplaint.find_by_presenting_complaint_id(presenting_complaint['obs_id'])

  concept_id = get_master_def_id(presenting_complaint['concept_id'], 'concept_name')
  value_coded = get_master_def_id(presenting_complaint['value_coded'], 'concept_name')

  if ids_presenting_complaints &&
     check_latest_record(presenting_complaint, ids_presenting_complaints)
    puts "Updating presenting complaints for
          #{presenting_complaint['person_id']}"
    ids_presenting_complaints.update(
      concept_id: concept_id,
      encounter_id: presenting_complaint['encounter_id'],
      value_coded: value_coded,
      voided: presenting_complaint['voided'],
      voided_by: presenting_complaint['voided_by'],
      voided_date: presenting_complaint['date_voided'],
      void_reason: presenting_complaint['void_reason'],
      app_date_created: presenting_complaint['date_created'],
      app_date_updated: presenting_complaint['date_changed'])
  else
    begin
      puts "Creating presenting complaints for #{presenting_complaint['person_id']}"
      ids_presenting_complaints                  = PresentingComplaint.new
      ids_presenting_complaints.presenting_complaint_id = presenting_complaint['obs_id']
      ids_presenting_complaints.concept_id       = concept_id
      ids_presenting_complaints.encounter_id     = presenting_complaint['encounter_id']
      ids_presenting_complaints.value_coded      = value_coded
      ids_presenting_complaints.voided           = presenting_complaint['voided']
      ids_presenting_complaints.voided_by        = presenting_complaint['voided_by']
      ids_presenting_complaints.voided_date      = presenting_complaint['date_voided']
      ids_presenting_complaints.void_reason      = presenting_complaint['void_reason']
      ids_presenting_complaints.app_date_created = presenting_complaint['date_created']
      ids_presenting_complaints.app_date_updated = presenting_complaint['date_changed']

      if ids_presenting_complaints.save
        puts 'Successfully saved presenting complaints'
        remove_failed_record('presenting_complaints', presenting_complaint['obs_id'].to_i)
      else
        puts 'Failed to save presenting complaints'
      end

    rescue Exception => e
      log_error_records('presenting_complaints', presenting_complaint['obs_id'].to_i, e)
    end
  end

  update_last_update('PresentingComplaints', presenting_complaint['updated_at'])
end
