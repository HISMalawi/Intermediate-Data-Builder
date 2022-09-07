# frozen_string_literal: true

class CreateSideEffectsHasMedicationPrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :side_effects_has_medication_prescriptions, primary_key: :side_effects_has_medication_prescription_id do |t|
<<<<<<< HEAD
      t.integer :side_effect_id, null: false
=======
      t.bigint :side_effect_id, null: false
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      t.bigint :medication_prescription_id, null: false

      t.timestamps
    end
    change_column :side_effects_has_medication_prescriptions, :side_effects_has_medication_prescription_id, :integer
  end
end
