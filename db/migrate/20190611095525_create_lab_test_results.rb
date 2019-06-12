class CreateLabTestResults < ActiveRecord::Migration[5.2]
  def change
    create_table       :lab_test_results, :primary_key => :test_result_id do |t|
    	t.integer          :lab_order_id
    	t.integer          :results_test_facility_id
    	t.integer          :test_measure_id
    	t.integer          :test_type_id
    	t.datetime        :test_result_date
    	t.string            :value_text
    	t.integer          :value_numeric
    	t.string            :value_modifier
    	t.integer          :value_min
    	t.integer          :value_max    	
    	t.bigint            :creator
    	t.boolean         :voided, null: false, default: 0
    	t.integer           :voided_by
    	t.datetime         :voided_date
    	t.string             :void_reason

      t.timestamps
    end
        add_foreign_key :lab_test_results, :lab_orders, column: :lab_order_id, primary_key: :lab_order_id
        add_foreign_key :lab_test_results, :master_definitions, column: :master_definition_id, primary_key: :master_definition_id
        add_foreign_key :lab_test_results, :master_definitions, column: :test_measure_id, primary_key: :master_definition_id
        add_foreign_key :lab_test_results, :sites, column: :results_test_facility_id, primary_key: :site_id
  end
end
