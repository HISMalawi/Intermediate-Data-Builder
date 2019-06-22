# frozen_string_literal: true

class CreateLabOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :lab_orders, primary_key: :lab_order_id do |t|
      t.string :tracking_number
      t.datetime :order_date
      t.bigint  :encounter_id
      t.bigint  :creator
      t.boolean :voided, null: false, default: 0
      t.bigint :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
