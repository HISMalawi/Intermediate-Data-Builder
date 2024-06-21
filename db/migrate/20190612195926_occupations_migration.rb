class OccupationsMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :occupations, :people, column: :person_id, primary_key: :person_id
<<<<<<< HEAD
    add_foreign_key :occupations, :master_definitions, column: :occupation, primary_key: :master_definition_id
=======
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  end
end
