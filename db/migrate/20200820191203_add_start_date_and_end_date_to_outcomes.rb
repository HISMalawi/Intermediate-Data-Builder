class AddStartDateAndEndDateToOutcomes < ActiveRecord::Migration[5.2]
  def change
  	add_column :outcomes, :start_date, :date
  	add_column :outcomes, :end_date, :date
  	rename_column :outcomes, :concept_id, :state 
  end
end
