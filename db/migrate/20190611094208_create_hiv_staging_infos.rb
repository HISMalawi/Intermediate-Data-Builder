class CreateHivStagingInfos < ActiveRecord::Migration[5.2]
  def change
    create_table   :hiv_staging_infos, :primary_key => :staging_id do |t|
    	t.integer  :encounter_id
    	t.datetime :start_date
    	t.datetime :date_enrolled
    	t.integer  :transfer_in, :limit => 2
    	t.datetime :re_initiated
    	t.datetime :age_at_initiation
    	t.integer  :age_in_days_at_initiation
    	t.integer  :voided, :limit =>2
    	t.integer  :voided_by
    	t.datetime :voided_date
    	t.string   :void_reason

      t.timestamps
    end
  end
end
