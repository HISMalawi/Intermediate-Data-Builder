class CreateFailedRecordTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :failed_record_types, primary_key: :failed_record_type_id do |t|
<<<<<<< HEAD
      t.text :name, null: false
=======
      t.string :name, null: false
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d

      t.timestamps
    end
    change_column :failed_record_types, :failed_record_type_id, :integer
<<<<<<< HEAD
=======
    add_index :failed_record_types, :name
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  end
end
