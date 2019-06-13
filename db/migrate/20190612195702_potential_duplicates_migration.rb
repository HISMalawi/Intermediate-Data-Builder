class PotentialDuplicatesMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :potential_duplicates, :people, column: :person_id_a, primary_key: :person_id
    add_foreign_key :potential_duplicates, :people, column: :person_id_b, primary_key: :person_id
    add_foreign_key :potential_duplicates, :duplicate_statuses, column: :duplicate_status_id, primary_key: :duplicate_status_id
  end
end
