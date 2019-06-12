class CreateHivStagingInfos < ActiveRecord::Migration[5.2]
  def change
    create_table  :hiv_staging_infos, :primary_key => :staging_id do |t|
    	t.date       :start_date
    	t.date       :date_enrolled
    	t.integer    :transfer_in, :limit => 2
    	t.datetime   :re_initiated, :limit => 2
    	t.integer    :age_at_initiation
    	t.integer    :age_in_days_at_initiation
    	t.boolean    :voided
    	t.integer    :voided_by, :limit=>8
    	t.datetime   :voided_date
    	t.string     :void_reason

        t.timestamps
    end
    add_foreign_key :hiv_staging_infos, :encounters, column: 'encounter', primary_key: 'encounter_id'
  end
end
