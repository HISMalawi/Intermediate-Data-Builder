class CreateDiagnosis < ActiveRecord::Migration[5.2]
  def change
    create_table :diagnosis, :primary_key => :diagnosis_id do |t|
    	t.integer    :encounter_id
    	t.integer    :primary_diagnosis, :limit => 2
    	t.integer    :concept_id
    	t.boolean    :voided
    	t.integer    :voided_by, :limit=>8
    	t.datetime   :voided_date
    	t.string     :void_reason

      t.timestamps
    end
    #add_foreign_key :diagnosis, :encounters, column: 'encounter', primary_key: 'encounter_id'
  end
end
