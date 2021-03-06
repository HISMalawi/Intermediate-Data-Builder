# frozen_string_literal: true

class CreateDeIdentifiedIdentifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :de_identified_identifiers, primary_key: :de_identified_identifier_id do |t|
      t.string :identifier, null: false
      t.bigint :person_id, null: false
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
