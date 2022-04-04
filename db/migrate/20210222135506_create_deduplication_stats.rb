class CreateDeduplicationStats < ActiveRecord::Migration[5.2]
  def change
    create_table :deduplication_stats do |t|
      t.string :process, null: :false
      t.datetime :start_time, null: :false
      t.datetime :end_time, null: :false
      t.bigint :number_of_records, null: :false, default: 0

      t.timestamps
    end
  end
end
