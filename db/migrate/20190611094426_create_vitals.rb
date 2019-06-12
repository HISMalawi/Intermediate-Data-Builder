class CreateVitals < ActiveRecord::Migration[5.2]
  def change
    create_table    :vitals, :primary_key => :vitals_id do |t|
     	t.integer     :encounter_id
    	t.integer     :concept_id
    	t.float       :value_numeric
    	t.boolean     :voided
    	t.integer     :voided_by
    	t.datetime    :voided_date
    	t.string      :void_reason

      t.timestamps
    end
  end
end

