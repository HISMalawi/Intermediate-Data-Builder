class CreateSideEffectsHasMedicationPrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table 	:side_effects_has_medication_prescriptions, :primary_key => :side_effects_has_medication_prescription_id do |t|
    	t.integer 	:side_effects_id, null: false
    	t.integer 	:medication_prescriptions_id, null: false
    
      t.timestamps
    end
  end
end
