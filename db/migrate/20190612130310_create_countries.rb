class CreateCountries < ActiveRecord::Migration[5.2]
		def change
			create_table :countries, :primary => :country_id do |t|
			t.string		:name
			t.boolean		:voided, null:false, default: 0
			t.integer		:voided_by
			t.integer		:void_reason

			t.timestamps
			end
		end
end
