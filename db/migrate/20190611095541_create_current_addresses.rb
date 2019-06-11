class CreateCurrentAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :current_addresses , :primary_key => :current_address_id do |t|
    	t.integer :person_id
    	t.integer :country_of_residence
    	t.integer :current_district
    	t.integer :current_ta
    	t.integer :current_village
    	t.string  :postal_code
    	t.string  :street_name
    	t.string  :house_number    	
    	t.integer :value_coded
    	t.integer :voided, :limit =>2
    	t.integer :voided_by
    	t.datetime :voided_date
    	t.string  :void_reason
      t.timestamps
    end
  end
end
