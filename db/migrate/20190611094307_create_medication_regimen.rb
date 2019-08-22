# frozen_string_literal: true

class CreateMedicationRegimen < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_regimen, primary_key: :medication_regimen_id, auto_increment: true do |t|
      t.string  :regimen
      t.string  :drug_composition
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string :void_reason

      t.timestamps
    end
  end
end
