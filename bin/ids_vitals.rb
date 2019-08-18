# frozen_string_literal: true

# Process IDS vitals functions

def vital_value_coded(vital)
  puts "processing vitals for person ID #{vital['person_id']}"

  vital_exist = Vital.find_by_vitals_id(vital['obs_id'])

  concept_id = get_master_def_id(vital['concept_id'], 'concept_name')
  value_coded = get_master_def_id(vital['value_coded'], 'concept_name')

  if vital_exist.blank?
    begin
      vitals = Vital.new
      vitals.vitals_id = vital['obs_id'].to_i
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
      vitals.app_date_created = vital['date_created']
      vitals.app_date_updated = vital['date_changed']
      vitals.voided = vital['voided']
      vitals.voided_by = vital['voided_by']
      vitals.voided_date = vital['date_voided']
      vitals.void_reason = vital['void_reason']
      vitals.save!

      remove_failed_record('vitals', vital['obs_id'].to_i)

      puts "Loaded vitals...for person ID #{vital['person_id']}"
    rescue Exception => e
      log_error_records('vitals', vital['obs_id'].to_i, e)
    end
  elsif (vital['date_changed'] || vital['date_created']).to_date > 
        (vital_exist['app_date_updated'] || vital_exist['app_date_created']).to_date
    vital_exist.update(voided: vital['voided'],
                       voided_by: vital['voided_by'],
                       voided_date: vital['date_voided'],
                       void_reason: vital['void_reason'])

    puts "Updated vitals record for person ID #{vital['person_id']}"
  end
  update_last_update('Vital', vital['updated_at'])
end
