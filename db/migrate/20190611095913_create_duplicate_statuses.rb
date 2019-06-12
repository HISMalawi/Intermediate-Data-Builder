class CreateDuplicateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table 	:duplicate_statuses , :primary_key => :duplicate_status_id do |t|
    	t.string 	:status
    	t.string 	:description
        t.timestamps
    end
  end
end
