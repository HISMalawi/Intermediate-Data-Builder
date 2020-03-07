# frozen_string_literal: true

class CreateMedicationPrescriptionHasMedicationRegimen < ActiveRecord::Migration[5.2]
  def change

    create_table :medication_prescription_has_medication_regimen, primary_key: :medication_prescription_has_medication_regimen_id, auto_increment: true do |t|
      t.bigint :medication_prescription_id, null: false
      t.bigint :medication_regimen_id, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint :voided_by
      t.datetime :voided_date
      t.string :void_reason

      t.timestamps
    end
    add_index :medication_prescription_has_medication_regimen, 
              ['medication_prescription_id', 'medication_regimen_id'], 
              unique: true,
              name: :medz_has_reg
  end
end
