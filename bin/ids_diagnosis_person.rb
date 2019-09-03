# frozen_string_literal: true

def ids_diagnosis_person(diag, primary_diagnosis, secondary_diagnosis)
  diagnosis = Diagnosis.find_by_encounter_id(diag['encounter_id'])
  if diagnosis && diag['encounter_datetime'].to_date >
                  (diagnosis['app_date_updated'] ||
                   diagnosis['app_date_created']).to_date
    assign_data(diag)
    diagnosis.update
  else
    diagnosis = Diagnosis.new
    assign_data(diag)
  end
end

def assign_data(diag)
  value_coded = get_master_def_id(diag[:value_coded], 'concept_name')
  diagnosis.encounter_id = diag['encounter_id']
  diagnosis.primary_diagnosis = (
  diag['concept_id'] == primary_diagnosis ? value_coded : '')
  diagnosis.secondary_diagnosis = (
  diag['concept_id'] == secondary_diagnosis ? value_coded : '')
  diagnosis.app_date_created = diag['encounter_datetime']
end
