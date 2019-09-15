class CreateFailedRecordTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :failed_record_types, primary_key: :failed_record_type_id do |t|
      t.string :name, null: false

      t.timestamps
    end
    change_column :failed_record_types, :failed_record_type_id, :integer
    add_index :failed_record_types, :name, type: :fulltext
  end
end
