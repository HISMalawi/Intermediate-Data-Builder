class CreateFailedRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :failed_records, primary_key: :id, auto_increment: true do |t|
      t.integer  :failed_record_type_id, null: false
      t.bigint   :record_id, null: false
      t.text     :errr_message

      t.timestamps
    end
    add_foreign_key :failed_records, :failed_record_types, column: :failed_record_type_id, primary_key: :failed_record_type_id
  end
end
