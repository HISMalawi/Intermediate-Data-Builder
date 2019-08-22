# frozen_string_literal: true

def ids_tb_statuses(tb_status)

  puts "processing TB Status for person ID #{tb_status['person_id']}"

  concept_id = get_master_def_id(tb_status['concept_id'], 'concept_name')
  value_coded = get_master_def_id(tb_status['value_coded'], 'concept_name')

  ids_tb_statuses = TbStatus.find_by_tb_status_id(tb_status['obs_id'])

  if ids_tb_statuses && check_latest_record(tb_status, ids_tb_statuses)
    puts "Updating patient tb status for #{tb_status['person_id']}"
    ids_tb_statuses.update(
    concept_id: concept_id,
    encounter_id: tb_status['encounter_id'],
    value_coded: value_coded,
    voided: presenting_complaint['voided'],
    voided_by: presenting_complaint['voided_by'],
    voided_date: presenting_complaint['date_voided'],
    void_reason: presenting_complaint['void_reason'],
    app_date_created: presenting_complaint['date_created'],
    app_date_updated: presenting_complaint['date_changed'])
    
  elsif ids_tb_statuses.blank?
    begin
      puts "Creating patient tb status for #{tb_status['person_id']}"
      ids_tb_statuses                    = TbStatus.new
      ids_tb_statuses.tb_status_id       = tb_status['obs_id']
      ids_tb_statuses.concept_id         = concept_id
      ids_tb_statuses.encounter_id       = tb_status['encounter_id']
      ids_tb_statuses.value_coded        = value_coded
      ids_tb_statuses.voided             = tb_status['voided']
      ids_tb_statuses.voided_by          = tb_status['voided_by']
      ids_tb_statuses.voided_date        = tb_status['date_voided']
      ids_tb_statuses.void_reason        = tb_status['void_reason']
      ids_tb_statuses.app_date_created   = tb_status['date_created']
      ids_tb_statuses.app_date_updated   = tb_status['date_changed']

      if ids_tb_statuses.save
        puts 'Successfully save tb statuses'
        remove_failed_record('tb_status', tb_status['obs_id'].to_i)
      else
        puts 'Failed to save tb statuses'
      end
        
    rescue Exception => e
      log_error_records('tb_status', tb_status['obs_id'].to_i, e)
    end
  end

  update_last_update('TbStatus', tb_status['updated_at'])
end
