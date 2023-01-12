class CreateFailedRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :failed_records, primary_key: :id, auto_increment: true do |t|
      t.integer  :failed_record_type_id, null: false
      t.bigint   :record_id, null: false
      t.text     :errr_message

      t.timestamps
    end
    add_foreign_key :failed_records, :failed_record_types, column: :failed_record_type_id, primary_key: :failed_record_type_id
<<<<<<< HEAD
=======
    add_index :failed_records, :record_id
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  end
end
