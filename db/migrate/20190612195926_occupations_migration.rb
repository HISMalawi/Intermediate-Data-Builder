class OccupationsMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :occupations, :people, column: :person_id, primary_key: :person_id
    add_foreign_key :occupations, :master_definitions, column: :occupation, primary_key: :master_definition_id
  end
end
