# frozen_string_literal: true

def ids_diagnosis_person(diag)
  primary_diagnosis = 6542
  secondary_diagnosis = 6543

  value_coded = get_master_def_id(diag[:value_coded], 'concept_name')

  pri_diag = (diag['concept_id'] == primary_diagnosis ? value_coded : '')
  sec_diag = (diag['concept_id'] == secondary_diagnosis ? value_coded : '')

  diagnosis = "(#{diag['encounter_id'].to_i},
               #{pri_diag},
               #{sec_diag},
               #{diag['voided'].to_i},
              #{diag['voided_by']},
              #{diag['date_voided']},
              '#{diag['void_reason']}',
              #{diag['creator'].to_i},
               #{diag['date_created']},
               #{diag['date_changed']}), "
  return diagnosis
end
