# frozen_string_literal: true

def ids_diagnosis_person(diag, primary_diagnosis, secondary_diagnosis)
  person = Person.find_by(person_id: diag['person_id'])

  value_coded = get_master_def_id(diag[:value_coded], 'concept_name')

  if person
    diagnosis = Diagnosis.new
    diagnosis.encounter_id = diag['encounter_id']

    diagnosis.primary_diagnosis = (
    diag['concept_id'] == primary_diagnosis ? value_coded : '')
    diagnosis.secondary_diagnosis = (
    diag['concept_id'] == secondary_diagnosis ? value_coded : '')
    diagnosis.app_date_created = diag['encounter_datetime']
    diagnosis.save!

    if diagnosis.save
      puts "Successfully populated diagnosis with person id #{diag['person_id']}"
    else
      puts "Failed to populated diagnosis with person id #{diag['person_id']}"
    end
  else
    puts 'diagnosis update code not available yet'
  end

  update_last_update('Diagnosis', diag['encounter_datetime'])
end
