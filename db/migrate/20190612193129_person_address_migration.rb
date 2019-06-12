class PersonAddressMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :person_addresses, :people, column: :person_id, primary_key: :person_id
	add_foreign_key :person_addresses, :locations, column: :district_id, primary_key: :location_id
	add_foreign_key :person_addresses, :locations, column: :traditional_authority_id, primary_key: :location_id
	add_foreign_key :person_addresses, :locations, column: :village_id, primary_key: :location_id
	add_foreign_key :person_addresses, :countries, column: :country_id, primary_key: :country_id
  end
end
