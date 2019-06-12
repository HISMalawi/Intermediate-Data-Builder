class CreatePersonNames < ActiveRecord::Migration[5.2]
  def change
    create_table :person_names, :primary_key => :person_name_id do |t|
    	t.bigint		:person_id
		t.string  		:given_name
		t.string  		:family_name
		t.string  		:middle_name
		t.string  		:maiden_name
		t.bigint		:creator
		t.boolean     :voided, null:false, default: 0
		t.bigint		:voided_by
		t.integer      :void_reason
		t.datetime	 :app_date_created, null:false
		t.datetime	 :app_date_updated, null:false

		t.timestamps
    end
		add_foreign_key :person_names, :people, column: :person_id, primary_key: :person_id
  end
end
