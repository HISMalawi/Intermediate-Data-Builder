# frozen_string_literal: true

class CreateMedicationRegimen < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_regimen, primary_key: :medication_regimen_id do |t|
      t.string  :regimen
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
    change_column :medication_regimen, :medication_regimen_id, :integer
  end
end
