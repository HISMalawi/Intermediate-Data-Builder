class HivStagingInfosMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :hiv_staging_infos, :encounters, column: :encounter_id, primary_key: :encounter_id
  end
end
