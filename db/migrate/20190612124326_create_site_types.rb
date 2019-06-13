class CreateSiteTypes < ActiveRecord::Migration[5.2]
	def change
		create_table :site_types, :primary_key => :site_type_id do |t|
			t.string	:description
			t.string	:site_type
			t.boolean	:voided, null:false, default: 0
			t.integer	:voided_by
			t.integer	:void_reason
			t.datetime	:app_date_created, null:false
			t.datetime	:app_date_updated, null:false

			t.timestamps
		end
		change_column :site_types, :site_type_id, :integer
	end
end
