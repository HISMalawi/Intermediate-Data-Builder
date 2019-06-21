# frozen_string_literal: true

def ids_tb_statuses(tb_status)
  ids_tb_statuses = TbStatus.find_by(encounter_id: tb_status['encounter_id'], concept_id: tb_status['concept_id'])

  concept_id = get_master_def_id(tb_status['concept_id'], 'concept_name')
  value_coded = get_master_def_id(tb_status['value_coded'], 'concept_name')

  if ids_tb_statuses.blank?
    puts "Creating patient tb status for #{tb_status['person_id']}"
    ids_tb_statuses = TbStatus.new
    ids_tb_statuses.concept_id = concept_id
    ids_tb_statuses.encounter_id = tb_status['encounter_id']
    ids_tb_statuses.value_coded = value_coded
  else
    puts "Updating patient tb status for #{tb_status['person_id']}"
    ids_tb_statuses.concept_id = concept_id
    ids_tb_statuses.encounter_id = tb_status['encounter_id']
    ids_tb_statuses.value_coded = value_coded
  end
  ids_tb_statuses.save!
  update_last_update('TbStatus', tb_status['updated_at'])
end

