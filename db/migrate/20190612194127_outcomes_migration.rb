class OutcomesMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :outcomes, :people, column: :person_id, primary_key: :person_id
    add_foreign_key :outcomes, :master_definitions, column: :concept_id, primary_key: :master_definition_id
  end
end
