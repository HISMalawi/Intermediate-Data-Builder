class OutcomesMigration < ActiveRecord::Migration[5.2]
  def change
        add_foreign_key :outcomes, :encounters, column: :encounter_id, primary_key: :encounter_id
        add_foreign_key :outcomes, :master_definitions, column: :concept_id, primary_key: :master_definition_id
  end
end
