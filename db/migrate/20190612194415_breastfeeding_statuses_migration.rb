class BreastfeedingStatusesMigration < ActiveRecord::Migration[5.2]
  def change
        add_foreign_key :breastfeeding_statuses, :encounters, column: :encounter_id, primary_key: :encounter_id
        add_foreign_key :breastfeeding_statuses, :master_definitions, column: :concept_id, primary_key: :master_definition_id
  end
end
