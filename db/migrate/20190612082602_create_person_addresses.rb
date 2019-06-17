# frozen_string_literal: true

class CreatePersonAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :person_addresses, primary_key: :person_address_id do |t|
      t.bigint  :person_id, null: false
      t.integer :district_id, null: false
      t.integer :traditional_authority_id, null: false
      t.integer :village_id, null: false
      t.integer :country_id
      t.bigint  :creator, null: false
      t.string  :landmark
      t.boolean :ancestry, null: false, default: 0
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
