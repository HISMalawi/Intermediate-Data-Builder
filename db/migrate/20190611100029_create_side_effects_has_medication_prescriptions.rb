class CreateSideEffectsHasMedicationPrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table 	:side_effects_has_medication_prescriptions do |t|
    	t.integer 	:side_effects_side_effect_id
    	t.integer 	:medication_prescriptions_prescription_id
    
      t.timestamps
    end
  end
end
