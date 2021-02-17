# frozen_string_literal: true

class CreateLabTestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :lab_test_results, primary_key: :test_result_id do |t|
      t.bigint  :lab_order_id, null: false
      t.string  :results_test_facility, null: false
      t.string  :sending_facility
      t.string  :test_type, null: false
      t.string  :sample_type
      t.string :test_measure
      t.datetime :test_result_date
      t.string :result
      t.boolean  :voided, null: false, default: 0
      t.integer  :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
   end
end
