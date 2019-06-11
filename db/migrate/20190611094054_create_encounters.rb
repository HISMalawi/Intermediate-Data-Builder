class CreateEncounters < ActiveRecord::Migration[5.2]
  def change
    create_table :encounters, :primary_key => :encounter_id do |t|
    	t.integer  :program_id
    	t.integer  :patient_id
    	t.datetime :visit_date
    	t.integer  :voided
    	t.integer  :voided_by
    	t.datetime :voided_date
    	t.string   :void_reason

      t.timestamps
    end
  end
end