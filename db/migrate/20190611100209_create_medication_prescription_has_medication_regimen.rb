# frozen_string_literal: true

class CreateMedicationPrescriptionHasMedicationRegimen < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_prescription_has_medication_regimen, primary_key: :medication_prescription_has_medication_regimen_id do |t|
      t.integer :medication_prescription_id, null: false
      t.integer :medication_regimen_id, null: false

      t.timestamps
    end
  end
end
