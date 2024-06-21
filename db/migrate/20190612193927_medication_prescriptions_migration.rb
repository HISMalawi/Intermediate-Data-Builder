class MedicationPrescriptionsMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :medication_prescriptions, :encounters, column: :encounter_id, primary_key: :encounter_id
    add_foreign_key :medication_prescriptions, :master_definitions, column: :drug_id, primary_key: :master_definition_id
  end
end
