# frozen_string_literal: true

def ids_presenting_complaints(presenting_complaint)
  ids_presenting_complaints = PresentingComplaint.find_by(encounter_id: presenting_complaint['encounter_id'], concept_id: presenting_complaint['concept_id'])

  concept_id = get_master_def_id(presenting_complaint['concept_id'])
  value_coded = get_master_def_id(presenting_complaint['value_coded'])

  if ids_presenting_complaints.blank?
    puts "Creating presenting complaints for #{presenting_complaint['person_id']}"
    ids_presenting_complaints = PresentingComplaint.new
    ids_presenting_complaints.concept_id = concept_id
    ids_presenting_complaints.encounter_id = presenting_complaint['encounter_id']
    ids_presenting_complaints.value_coded = value_coded
  else
    puts "Updating presenting complaints for #{presenting_complaint['person_id']}"
    ids_presenting_complaints.concept_id = concept_id
    ids_presenting_complaints.encounter_id = presenting_complaint['encounter_id']
    ids_presenting_complaints.value_coded = value_coded
  end
  ids_presenting_complaints.save!
  update_last_update('PresentingComplaint', presenting_complaint['updated_at'])
end
