# frozen_string_literal: true

# Process IDS vitals functions

def vital_value_coded(vital)
  person = Person.find_by_person_id(vital['person_id'])

  concept_id = get_master_def_id(vital['concept_id'], 'concept_name')
  value_coded = get_master_def_id(vital['value_coded'], 'concept_name')

  if person
    vitals = Vital.new
    vitals.encounter_id = vital['encounter_id']
    vitals.concept_id = concept_id
    vitals.value_coded = begin
      value_coded
                         rescue StandardError
                           nil
    end
    vitals.value_numeric = begin
      vital['value_numeric']
                           rescue StandardError
                             nil
    end
    vitals.value_text = begin
      vital['value_text']
                        rescue StandardError
                          nil
    end
    vitals.value_modifier = begin
      vital['value_modifier']
                            rescue StandardError
                              nil
    end
    vitals.value_min = begin
      ''
                       rescue StandardError
                         nil
    end
    vitals.value_max = begin
      ''
                       rescue StandardError
                         nil
    end
    vitals.value_max = begin
      ''
                       rescue StandardError
                         nil
    end
    vitals.app_date_created = vital['obs_datetime']
    vitals.save!
    puts "Loading vitals...for person ID #{vital['person_id']}"
  else
    puts "No person record with person id #{vital['person_id']}"
  end
  update_last_update('Vital', vital[:update_at])
end
