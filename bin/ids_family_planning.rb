# frozen_string_literal: true

def ids_family_planning(family_planning)
  ids_family_planning = FamilyPlanning.find_by(encounter_id: family_planning['encounter_id'], concept_id: family_planning['concept_id'])

  concept_id = get_master_def_id(family_planning['concept_id'], 'concept_name')
  value_coded = get_master_def_id(family_planning['value_coded'], 'concept_name')

  if ids_family_planning.blank?
    puts "Creating family planning for #{family_planning['person_id']}"
    ids_family_planning = FamilyPlanning.new
    ids_family_planning.concept_id = concept_id
    ids_family_planning.encounter_id = family_planning['encounter_id']
    ids_family_planning.value_coded = value_coded
  else
    puts "Updating family planning for #{family_planning['person_id']}"
    ids_family_planning.concept_id = concept_id
    ids_family_planning.encounter_id = family_planning['encounter_id']
    ids_family_planning.value_coded = value_coded
  end
  ids_family_planning.save!
  update_last_update('FamilyPlanning', family_planning['updated_at'])
end

