class CreatePersonNames < ActiveRecord::Migration[5.2]
  def change
    create_table :person_names, :primary_key => :person_name_id do |t|
    	t.integer		:person_id, null:false
		t.string  		:given_name, null:false
		t.string  		:family_name, null:false
		t.string  		:middle_name
		t.string  		:maiden_name
		t.bigint		:creator, null:false
		t.boolean     :voided, null:false, default: 0
		t.bigint		:voided_by
		t.integer      :void_reason
		t.datetime	 :app_date_created, null:false
		t.datetime	 :app_date_updated, null:false

		t.timestamps
    end
  end
end
