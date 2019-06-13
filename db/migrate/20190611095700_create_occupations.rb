class CreateOccupations < ActiveRecord::Migration[5.2]
  def change
    create_table     :occupations , :primary_key => :occupation_id do |t|
    	t.bigint      :person_id, null: false
    	t.integer      :occupation, null: false
      t.bigint        :creator
    	t.boolean      :voided, null: false, default: 0
    	t.integer      :voided_by
    	t.datetime    :voided_date
    	t.string        :void_reason

      t.timestamps
    end
       change_column :occupations, :occupation_id, :integer
  end
end
