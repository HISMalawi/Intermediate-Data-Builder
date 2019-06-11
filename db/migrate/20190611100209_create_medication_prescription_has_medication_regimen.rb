class CreateMedicationPrescriptionHasMedicationRegimen < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_prescription_has_medication_regimen do |t|

    	t.integer :medication_prescription_medication_id
    	t.integer :medication_regimens_regimen_id
      t.timestamps
    end
  end
end
