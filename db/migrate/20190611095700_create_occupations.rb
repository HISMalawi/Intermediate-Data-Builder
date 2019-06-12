class CreateOccupations < ActiveRecord::Migration[5.2]
  def change
    create_table     :occupations , :primary_key => :occupation_id do |t|
    	t.integer      :person_id, null: false
    	t.integer      :occupation, null: false
      t.bigint        :creator
    	t.boolean      :voided, null: false, default: 0
    	t.integer      :voided_by
    	t.datetime    :voided_date
    	t.string        :void_reason

      t.timestamps
    end
  end
  def up
        add_foreign_key :occupations, :people, column: :person_id, primary_key: :person_id
       add_foreign_key :occupations, :master_definitions, column: :occupation, primary_key: :master_definition_id
    end
end
