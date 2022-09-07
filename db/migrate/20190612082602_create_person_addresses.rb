# frozen_string_literal: true

class CreatePersonAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :person_addresses, primary_key: :person_address_id do |t|
      t.bigint  :person_id, null: false
<<<<<<< HEAD
      t.integer :home_district_id, null: false
      t.integer :home_traditional_authority_id, null: false
      t.integer :home_village_id, null: false
      t.integer :current_district_id, null: false
      t.integer :current_traditional_authority_id, null: false
      t.integer :current_village_id, null: false
      t.integer :country_id, null: false
=======
      t.string :home_district_id
      t.string :home_traditional_authority_id
      t.string :home_village_id
      t.string :current_district_id
      t.string :current_traditional_authority_id
      t.string :current_village_id
      t.string :country_id
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      t.bigint  :creator, null: false
      t.string  :landmark
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
