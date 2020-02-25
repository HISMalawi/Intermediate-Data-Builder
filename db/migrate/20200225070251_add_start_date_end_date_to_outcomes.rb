class AddStartDateEndDateToOutcomes < ActiveRecord::Migration[5.2]
  def change
  	add_column :outcomes, :start_date, :datetime
  	add_column :outcomes, :end_date, :datetime
  end
end
