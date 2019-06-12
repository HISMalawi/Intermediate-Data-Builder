class GuardianMigration < ActiveRecord::Migration[5.2]
  def change
      	add_foreign_key :guardians, :people, column: :person_id, primary_key: :person_id
		add_foreign_key :guardians, :master_definitions, column: :relationship_type_id, primary_key: :master_definition_id
  end
end
