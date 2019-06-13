class LabOrdersMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :lab_orders, :encounters, column: :encounter_id, primary_key: :encounter_id
  end
end
