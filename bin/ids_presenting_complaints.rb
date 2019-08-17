# frozen_string_literal: true

def ids_presenting_complaints(presenting_complaint)
  ids_presenting_complaints = PresentingComplaint.find_by(encounter_id: presenting_complaint['encounter_id'],
                                                          concept_id: presenting_complaint['concept_id'])

  concept_id = get_master_def_id(presenting_complaint['concept_id'], 'concept_name')
  value_coded = get_master_def_id(presenting_complaint['value_coded'], 'concept_name')

  if ids_presenting_complaints && presenting_complaint['date_changed'] >
                                  ids_presenting_complaints['app_date_updated']
    puts "Updating presenting complaints for #{presenting_complaint['person_id']}"
    ids_presenting_complaints.update(concept_id: concept_id,
                                     encounter_id: presenting_complaint['encounter_id'],
                                     value_coded: value_coded,
                                     app_date_created: presenting_complaint['date_created'],
                                     app_date_updated: presenting_complaint['date_changed'])
  else
    begin
      puts "Creating presenting complaints for #{presenting_complaint['person_id']}"
      ids_presenting_complaints = PresentingComplaint.new
      ids_presenting_complaints.concept_id = concept_id
      ids_presenting_complaints.encounter_id = presenting_complaint['encounter_id']
      ids_presenting_complaints.value_coded = value_coded
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
