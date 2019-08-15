# frozen_string_literal: true

def ids_presenting_complaints(presenting_complaint, failed_records)
  ids_presenting_complaints = PresentingComplaint.find_by(encounter_id: presenting_complaint['encounter_id'], concept_id: presenting_complaint['concept_id'])

  concept_id = get_master_def_id(presenting_complaint['concept_id'], 'concept_name')
  value_coded = get_master_def_id(presenting_complaint['value_coded'], 'concept_name')

  if ids_presenting_complaints
    puts "Updating presenting complaints for #{presenting_complaint['person_id']}"
    ids_presenting_complaints.update(concept_id: concept_id)
    ids_presenting_complaints.update(encounter_id: presenting_complaint['encounter_id'])
    ids_presenting_complaints.update(value_coded: value_coded)
  else
    begin
      puts "Creating presenting complaints for #{presenting_complaint['person_id']}"
      ids_presenting_complaints = PresentingComplaint.new
      ids_presenting_complaints.concept_id = concept_id
      ids_presenting_complaints.encounter_id = presenting_complaint['encounter_id']
      ids_presenting_complaints.value_coded = value_coded

      if ids_presenting_complaints.save
        puts 'Successfully saved presenting complaints'
      else
        puts 'Failed to save presenting complaints'
      end
    if failed_records.include?(presenting_complaint['obs_id'].to_s)
        remove_failed_record('PersonComplaints', presenting_complaint['obs_id'])
      end
    rescue Exception => e
      File.write('log/app_errors.log', e.message, mode: 'a')
      log_error_records('PersonComplaints', presenting_complaint['obs_id'].to_i)
    end
  end

  update_last_update('PresentingComplaints', presenting_complaint['updated_at'])
end
