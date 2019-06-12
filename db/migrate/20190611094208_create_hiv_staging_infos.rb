class CreateHivStagingInfos < ActiveRecord::Migration[5.2]
  def change
    create_table  :hiv_staging_infos, :primary_key => :staging_info_id do |t|
            t.bigint      :encounter_id
            t.date       :start_date
            t.date       :date_enrolled
            t.integer    :transfer_in
            t.integer    :re_initiated
            t.integer    :age_at_initiation
            t.integer    :age_in_days_at_initiation
            t.boolean   :voided, null: false, default: 0
            t.bigint       :voided_by
            t.datetime   :voided_date
            t.string       :void_reason

        t.timestamps
        end
    end
end
