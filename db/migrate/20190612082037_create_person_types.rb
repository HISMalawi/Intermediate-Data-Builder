class CreatePersonTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :person_types, :primary_key => :person_type_id do |t|
   
		t.string  		:person_type_name
		t.string  		:person_type_description
		t.boolean     :voided, null:false, default: 0
		t.bigint		:voided_by
		t.integer      :void_reason

		t.timestamps
    end
      change_column :person_types, :person_type_id, :bigint
	end
end
