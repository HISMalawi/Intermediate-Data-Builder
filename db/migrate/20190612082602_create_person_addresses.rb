class CreatePersonAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :person_addresses do |t|
   	  t.integer      :person_id
      t.integer      :district_id
      t.integer      :traditional_authority_id
      t.integer      :village_id
      t.integer      :country_id
      t.string       :landmark
      t.boolean      :ancestry, null: false, default: 0

      t.timestamps
    end

    change_column :person_addresses, :person_address_id, :integer, limit: 8
    change_column :person_addresses, :person_id, :integer, limit: 8
    change_column :person_addresses, :district_id, :integer, limit: 8
    change_column :person_addresses, :traditional_authority_id, :integer, limit: 8
    change_column :person_addresses, :village_id, :integer, limit: 8
    change_column :person_addresses, :country_id, :integer, limit: 8

    add_foreign_key :person_addresses, :person, column: :person_id, primary_key: :person_id
    add_foreign_key :person_addresses, :locations, column: :district_id, primary_key: :location_id
    add_foreign_key :person_addresses, :locations, column: :traditional_authority_id, primary_key: :location_id
    add_foreign_key :person_addresses, :locations, column: :village_id, primary_key: :location_id
    add_foreign_key :person_addresses, :countries, column: :country_id, primary_key: :country_id
  end
end
