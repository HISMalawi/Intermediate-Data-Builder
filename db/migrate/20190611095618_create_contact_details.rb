class CreateContactDetails < ActiveRecord::Migration[5.2]
  def change
    create_table       :contact_details , :primary_key => :contact_details_id do |t|
    	t.integer      :person_id
    	t.string       :home_phone_number
    	t.string       :cell_phone_number
    	t.string       :work_phone_number
    	t.string       :email_address
    	t.integer      :value_coded
    	t.boolean      :voided
    	t.integer      :voided_by
    	t.datetime     :voided_date
    	t.string       :void_reason

      t.timestamps
    end
  end
end
