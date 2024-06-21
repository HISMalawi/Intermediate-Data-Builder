class CreatePersonHasTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :person_has_types, primary_key: :person_has_type_id do |t|
      t.bigint :person_id
      t.bigint :person_type_id

      t.timestamps
    end
    add_foreign_key :person_has_types, :people, column: :person_id, primary_key: :person_id
    add_foreign_key :person_has_types, :person_types, column: :person_type_id, primary_key: :person_type_id
  end
end
