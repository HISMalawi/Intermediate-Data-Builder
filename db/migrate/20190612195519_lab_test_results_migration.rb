class LabTestResultsMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :lab_test_results, :lab_orders, column: :lab_order_id, primary_key: :lab_order_id
    add_foreign_key :lab_test_results, :master_definitions, column: :test_type_id, primary_key: :master_definition_id
    add_foreign_key :lab_test_results, :master_definitions, column: :test_measure_id, primary_key: :master_definition_id
    add_foreign_key :lab_test_results, :sites, column: :results_test_facility_id, primary_key: :site_id
  end
end
