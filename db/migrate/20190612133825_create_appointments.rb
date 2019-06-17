# frozen_string_literal: true

class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments, primary_key: :appointment_id do |t|
      t.bigint :encounter_id, null: false
      t.datetime :appointment_date, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint    :voided_by
      t.bigint    :creator, null: false
      t.datetime  :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
