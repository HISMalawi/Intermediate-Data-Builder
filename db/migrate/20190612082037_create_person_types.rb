class CreatePersonTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :person_types, :primary_key => :person_type_id do |t|
    	t.bigint		:person_id
		t.string  		:person_type_name
		t.string  		:person_type_description
		t.bigint  		:creator
		t.boolean     :voided, null:false, default: 0
		t.bigint		:voided_by
		t.integer      :void_reason
		t.datetime	 :app_date_created, null:false
		t.datetime	 :app_date_updated, null:false

		t.timestamps
    end
		add_foreign_key :person_types, :people, column: :person_id, primary_key: :person_id
  end
end
