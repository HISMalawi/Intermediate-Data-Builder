class CreateDeDuplicators < ActiveRecord::Migration[5.2]
  def change
    create_table :de_duplicators, :primary_key => :de_duplicator_id do |t|
<<<<<<< HEAD
      t.bigint   :person_id, null: false
=======
      t.bigint   :person_id, null: false, unique: true
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      t.string   :person_de_duplicator, null: false

      t.timestamps
    end
    add_foreign_key :de_duplicators, :people, column: :person_id, primary_key: :person_id
<<<<<<< HEAD
    add_index :de_duplicators, :person_de_duplicator, type: :fulltext
  end
end
=======
    add_index :de_duplicators, :person_de_duplicator
  end
end
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
