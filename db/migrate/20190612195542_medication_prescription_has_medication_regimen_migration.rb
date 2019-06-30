class MedicationPrescriptionHasMedicationRegimenMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :medication_prescription_has_medication_regimen, :medication_prescriptions, column: :enocounter_id, primary_key: :regimen_id
    add_foreign_key :medication_prescription_has_medication_regimen, :medication_regimen, column: :medication_regimen_id, primary_key: :medication_regimen_id
  end
end
