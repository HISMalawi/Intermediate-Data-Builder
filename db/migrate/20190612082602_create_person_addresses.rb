class CreatePersonAddresses < ActiveRecord::Migration[5.2]
    def change
      create_table    :person_addresses,  :primary_key => :person_address_id do |t|
        t.bigint          :person_id, null: false
        t.integer        :district_id, null: false
        t.integer        :traditional_authority_id, null: false
        t.integer        :village_id, null: false
        t.integer        :country_id, null: false
        t.bigint          :creator, null: false
        t.string          :landmark
        t.boolean      :ancestry, null: false, default: 0

        t.timestamps
        end
    end
    def up
        add_foreign_key :person_addresses, :people, column: :person_id, primary_key: :person_id
        add_foreign_key :person_addresses, :locations, column: :district_id, primary_key: :location_id
        add_foreign_key :person_addresses, :locations, column: :traditional_authority_id, primary_key: :location_id
        add_foreign_key :person_addresses, :locations, column: :village_id, primary_key: :location_id
        add_foreign_key :person_addresses, :countries, column: :country_id, primary_key: :country_id
    end
end
