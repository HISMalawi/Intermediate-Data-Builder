class RelationshipsMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :relationships, :people, column: :person_id_a, primary_key: :person_id
    add_foreign_key :relationships, :people, column: :person_id_b, primary_key: :person_id
  end
end
