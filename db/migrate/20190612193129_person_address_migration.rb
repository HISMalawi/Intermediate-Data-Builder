# frozen_string_literal: true

class PersonAddressMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :person_addresses, :people, column: :person_id, primary_key: :person_id
<<<<<<< HEAD
    add_foreign_key :person_addresses, :locations, column: :home_district_id, primary_key: :location_id
    add_foreign_key :person_addresses, :locations, column: :home_traditional_authority_id, primary_key: :location_id
    add_foreign_key :person_addresses, :locations, column: :home_village_id, primary_key: :location_id
    add_foreign_key :person_addresses, :locations, column: :current_district_id, primary_key: :location_id
    add_foreign_key :person_addresses, :locations, column: :current_traditional_authority_id, primary_key: :location_id
    add_foreign_key :person_addresses, :locations, column: :current_village_id, primary_key: :location_id
    add_foreign_key :person_addresses, :countries, column: :country_id, primary_key: :country_id
=======
    #add_foreign_key :person_addresses, :locations, column: :home_district_id, primary_key: :location_id
    #add_foreign_key :person_addresses, :locations, column: :home_traditional_authority_id, primary_key: :location_id
    #add_foreign_key :person_addresses, :locations, column: :home_village_id, primary_key: :location_id
    #add_foreign_key :person_addresses, :locations, column: :current_district_id, primary_key: :location_id
    #add_foreign_key :person_addresses, :locations, column: :current_traditional_authority_id, primary_key: :location_id
    #add_foreign_key :person_addresses, :locations, column: :current_village_id, primary_key: :location_id
    #add_foreign_key :person_addresses, :countries, column: :country_id, primary_key: :country_id
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  end
end
