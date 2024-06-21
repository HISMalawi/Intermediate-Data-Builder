class MedicationPrescriptionHasMedicationRegimenMigration < ActiveRecord::Migration[5.2]
  def change
<<<<<<< HEAD
    add_foreign_key :medication_prescription_has_medication_regimen, :medication_prescriptions, column: :medication_prescription_encounter_id, primary_key: :encounter_id
=======
    #add_foreign_key :medication_prescription_has_medication_regimen, :medication_prescriptions, column: :medication_prescription_encounter_id, primary_key: :encounter_id
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
    add_foreign_key :medication_prescription_has_medication_regimen, :medication_regimen, column: :medication_regimen_id, primary_key: :medication_regimen_id
  end
end
