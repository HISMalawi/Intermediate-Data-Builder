class HivStagingInfosMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :hiv_staging_infos, :people, column: :person_id, primary_key: :person_id
  end
end
