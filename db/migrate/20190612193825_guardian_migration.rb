class GuardianMigration < ActiveRecord::Migration[5.2]
  def change
      	add_foreign_key :guardians, :person, column: :person_id, primary_key: :person_id
	add_foreign_key :guardians, :relationships, column: :relationship_id, primary_key: :relationship_id
  end
end
