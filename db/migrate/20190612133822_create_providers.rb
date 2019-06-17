# frozen_string_literal: true

class CreateProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :providers, primary_key: :provider_id do |t|
      t.integer :person_name_id
      t.bigint    :person_type_id, null: false
      t.bigint    :person_name_id, null: false
      t.bigint    :creator, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint :voided_by
      t.integer :void_reason

      t.timestamps
    end
  end
end
