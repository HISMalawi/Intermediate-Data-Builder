class PeopleMigration < ActiveRecord::Migration[5.2]
  def change
      add_foreign_key :people, :person_types, column: :person_type_id, primary_key: :person_type_id
  end
end
