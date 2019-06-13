class CreateEncounters < ActiveRecord::Migration[5.2]
  def change
    create_table   :encounters, :primary_key => :encounter_id do |t|
      t.integer        :encounter_type_id
    	t.integer       :program_id
    	t.integer      :person_id
    	t.datetime   :visit_date
    	t.boolean    :voided, null: false, default: 0
      t.bigint        :voided_by
      t.datetime   :voided_date
      t.string       :void_reason


      t.timestamps
    end
      change_column :encounters, :encounter_id, :integer
  end
 
end