class DiagnosisMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :diagnosis, :encounters, column: :encounter_id, primary_key: :encounter_id
    add_foreign_key :diagnosis, :master_definitions, column: :primary_diagnosis, primary_key: :master_definition_id
    add_foreign_key :diagnosis, :master_definitions, column: :secondary_diagnosis, primary_key: :master_definition_id
  end
end
