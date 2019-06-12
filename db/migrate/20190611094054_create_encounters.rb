class CreateEncounters < ActiveRecord::Migration[5.2]
  def change
    create_table   :encounters, :primary_key => :encounter_id do |t|
      t.integer    :encounter_type_id, :limit =>8
    	t.integer    :program_id, :limit =>8
    	t.integer    :patient_id
    	t.datetime   :visit_date
    	t.boolean    :voided
    	t.integer    :voided_by, :limit=>8
    	t.datetime   :voided_date
    	t.string     :void_reason

      t.timestamps
    end
    add_foreign_key :encounters, :person, column: 'person', primary_key: 'person_id'
  end
end