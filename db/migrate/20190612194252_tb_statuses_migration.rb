class TbStatusesMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :tb_statuses, :encounters, column: :encounter_id, primary_key: :encounter_id
  end
end
