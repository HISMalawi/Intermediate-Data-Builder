# frozen_string_literal: true

class CreateMedicationPrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_prescriptions, primary_key: :medication_prescription_id do |t|
      t.bigint  :drug_id
      t.bigint  :encounter_id
      t.datetime  :start_date
      t.datetime  :end_name
      t.string :instructions
      t.boolean :voided, null: false, default: 0
      t.bigint :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end

    change_column :medication_prescriptions, :medication_prescription_id, :integer
  end
end
