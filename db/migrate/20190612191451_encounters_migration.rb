class EncountersMigration < ActiveRecord::Migration[5.2]
  def change
  	add_foreign_key :encounters, :master_definitions, column: :encounter_type_id, primary_key: :master_definition_id
    add_foreign_key :encounters, :master_definitions, column: :program_id, primary_key: :master_definition_id
    add_foreign_key :encounters, :people, column: :person_id, primary_key: :person_id
  end
end
