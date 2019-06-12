class PregnantStatusesMigration < ActiveRecord::Migration[5.2]
  def change
      add_foreign_key :pregnant_statuses, :encounters, column: :encounter_id, primary_key: :encounter_id
      add_foreign_key :pregnant_statuses, :master_definitions, column: :concept_id, primary_key: :concept_id
  end
end
