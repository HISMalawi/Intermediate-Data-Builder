# frozen_string_literal: true

class CreateMedicationPrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_prescriptions, primary_key: :medication_prescription_id, auto_increment: true do |t|
      t.bigint  :drug_id
      t.bigint  :encounter_id
      t.datetime  :start_date
      t.datetime  :end_date
      t.string :instructions
      t.boolean :voided, null: false, default: 0
      t.bigint :voided_by
      t.datetime :voided_date
      t.string :void_reason
<<<<<<< HEAD
=======
      t.bigint :creator
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
