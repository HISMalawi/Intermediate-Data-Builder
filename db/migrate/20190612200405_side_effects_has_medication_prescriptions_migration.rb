class SideEffectsHasMedicationPrescriptionsMigration < ActiveRecord::Migration[5.2]
  def change
<<<<<<< HEAD
    # add_foreign_key :side_effects_has_medication_prescriptions, :medication_prescriptions, column: :medication_prescription_id, primary_key: :medication_prescription_id
    # add_foreign_key :side_effects_has_medication_prescriptions, :side_effects, column: :side_effect_id, primary_key: :side_effect_id
=======
     add_foreign_key :side_effects_has_medication_prescriptions, :medication_prescriptions, column: :medication_prescription_id, primary_key: :medication_prescription_id
     add_foreign_key :side_effects_has_medication_prescriptions, :side_effects, column: :side_effect_id, primary_key: :side_effect_id
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  end
end
