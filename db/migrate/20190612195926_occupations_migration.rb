class OccupationsMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :occupations, :people, column: :person_id, primary_key: :person_id
  end
end
