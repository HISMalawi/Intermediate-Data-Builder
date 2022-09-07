class AddFromLastUpdate < ActiveRecord::Migration[5.2]
  def change
  	add_column :deduplication_stats, :from_update, :datetime, null: false
  end
end
