class CreateSites < ActiveRecord::Migration[5.2]
	def change
		create_table :sites, :primary_key => :site_id do |t|

			t.string	:site_name
			t.string	:short_name
			t.string	:site_description
			t.integer	:site_type_id
			t.boolean	:voided, null:false, default: 0
			t.bigint	:voided_by
			t.integer	:void_reason
			t.datetime	:app_date_created, null:false
			t.datetime	:app_date_updated, null:false

			t.timestamps
		end
		change_column :sites, :site_id, :integer
	end
end
