class CreatePotentialDuplicates < ActiveRecord::Migration[5.2]
  def change
    create_table    :potential_duplicates, :primary_key => :potential_duplicate_id do |t|
    	t.bigint            :person_id_a
    	t.bigint            :person_id_b
    	t.integer          :duplicate_status_id
    	t.float             :score
        t.bigint            :creator
    	t.boolean        :voided, null: false, default: 0
    	t.integer          :voided_by
    	t.datetime        :voided_date
    	t.string            :void_reason

      t.timestamps
    end
        add_foreign_key :potential_duplicates, :people, column: :person_id_a, primary_key: :person_id
        add_foreign_key :potential_duplicates, :people, column: :person_id_b, primary_key: :person_id
        add_foreign_key :potential_duplicates, :duplicate_statuses, column: :duplicate_status_id, primary_key: :duplicate_status_id
  end
end
