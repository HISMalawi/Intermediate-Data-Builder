class CreatePotentialDuplicates < ActiveRecord::Migration[5.2]
  def change
    create_table    :potential_duplicates, :primary_key => :potential_duplicate_id do |t|
    	t.integer   :person_id_a
    	t.integer   :person_id_b
    	t.integer   :status
    	t.float     :score
    	t.integer   :concept_id
    	t.integer   :value_coded
    	t.boolean   :voided
    	t.integer   :voided_by
    	t.datetime  :voided_date
    	t.string    :void_reason

      t.timestamps
    end
  end
end
