class SideEffectsHasMedicationPrescriptionsMigration < ActiveRecord::Migration[5.2]
  def change
  	  	add_foreign_key :side_effects_has_medication_prescriptions, :medication_prescriptions, column: :medication_prescription_id, primary_key: :medication_prescription_id
    add_foreign_key :side_effects_has_medication_prescriptions, :side_effects, column: :side_effect_id, primary_key: :side_effect_id
  end
end
