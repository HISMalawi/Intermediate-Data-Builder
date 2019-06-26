# frozen_string_literal: true

class CreateMedicationAdherences < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_adherences, primary_key: :adherence_id do |t|
      t.bigint :medication_dispensation_id
      t.bigint  :drug_id
      t.float :adherence
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
    end
end
