# frozen_string_literal: true

def ids_tb_statuses(tb_status, failed_records)

  concept_id = get_master_def_id(tb_status['concept_id'], 'concept_name')
  value_coded = get_master_def_id(tb_status['value_coded'], 'concept_name')

  ids_tb_statuses = TbStatus.find_by(encounter_id: tb_status['encounter_id'], concept_id: concept_id)

  if ids_tb_statuses
    puts "Updating patient tb status for #{tb_status['person_id']}"
    ids_tb_statuses.update(concept_id: concept_id)
    ids_tb_statuses.update(encounter_id: tb_status['encounter_id'])
    ids_tb_statuses.update(value_coded: value_coded)
  else
    begin
      puts "Creating patient tb status for #{tb_status['person_id']}"
      ids_tb_statuses = TbStatus.new
      ids_tb_statuses.concept_id = concept_id
      ids_tb_statuses.encounter_id = tb_status['encounter_id']
      ids_tb_statuses.value_coded = value_coded

      if ids_tb_statuses.save
        puts 'Successfully save tb statuses'
      else
        puts 'Failed to save tb statuses'
      end

      if failed_records.include?(tb_status['obs_id'].to_s)
        remove_failed_record('TbStatus', tb_status['obs_id'])
      end
    rescue Exception => e
      File.write('log/app_errors.log', e.message, mode: 'a')
      log_error_records('TbStatus', tb_status['obs_id'].to_i)
    end
  end

  update_last_update('TbStatus', tb_status['updated_at'])
end

