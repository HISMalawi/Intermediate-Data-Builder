class PresentingComplaintsMigration < ActiveRecord::Migration[5.2]
  def change
        add_foreign_key :presenting_complaints, :encounters, column: :encounter_id, primary_key: :encounter_id
        add_foreign_key :presenting_complaints, :master_definitions, column: :concept_id, primary_key: :master_definition_id
  end
end
