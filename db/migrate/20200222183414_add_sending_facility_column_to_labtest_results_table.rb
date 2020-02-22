class AddSendingFacilityColumnToLabtestResultsTable < ActiveRecord::Migration[5.2]
  def change
  	add_column :lab_test_results, :sending_facility, :string
  end
end
