class CreateDeDuplicators < ActiveRecord::Migration[5.2]
  def change
    create_table :de_duplicators, :primary_key => :de_duplicator_id do |t|
      t.bigint   :person_id, null: false, unique: true
      t.string   :person_de_duplicator, null: false

      t.timestamps
    end
    add_foreign_key :de_duplicators, :people, column: :person_id, primary_key: :person_id
    add_index :de_duplicators, :person_de_duplicator
  end
end
