class CreateLabTestResults < ActiveRecord::Migration[5.2]
  def change
    create_table       :lab_test_results, :primary_key => :test_result_id do |t|
    	t.integer      :lab_order_id
    	t.integer      :results_test_facility_id
    	t.integer      :test_measure_id
    	t.integer      :test_type_id
    	t.datetime     :test_result_date
    	t.string       :value_text
    	t.integer      :value_numeric
    	t.string       :value_modifier
    	t.integer      :value_min
    	t.integer      :value_max    	
    	t.integer      :value_coded
    	t.integer      :voided, :limit =>2
    	t.integer      :voided_by
    	t.datetime     :voided_date
    	t.string       :void_reason

      t.timestamps
    end
  end
end
