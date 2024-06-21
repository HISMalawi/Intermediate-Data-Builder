class LabTestResultsMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :lab_test_results, :lab_orders, column: :lab_order_id, primary_key: :lab_order_id
  end
end
