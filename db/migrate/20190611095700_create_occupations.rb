class CreateOccupations < ActiveRecord::Migration[5.2]
  def change
    create_table     :occupations , :primary_key => :occupation_id do |t|
    	t.integer      :person_id
    	t.integer      :occupation
    	t.integer      :value_coded
    	t.boolean      :voided
    	t.integer      :voided_by
    	t.datetime     :voided_date
    	t.string       :void_reason

      t.timestamps
    end
  end
end
