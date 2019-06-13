class MedicationAdherencesMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :medication_adherences, :master_definitions, column: :drug_id, primary_key: :master_definition_id
    add_foreign_key :medication_adherences, :medication_dispensations, column: :medication_dispensation_id, primary_key: :medication_dispensation_id
  end
end
