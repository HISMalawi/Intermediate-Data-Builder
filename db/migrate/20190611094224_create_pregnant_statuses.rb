# frozen_string_literal: true

class CreatePregnantStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :pregnant_statuses, primary_key: :pregnant_status_id do |t|
      t.bigint  :concept_id
      t.bigint  :encounter_id
      t.bigint  :value_coded
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.bigint  :creator
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
