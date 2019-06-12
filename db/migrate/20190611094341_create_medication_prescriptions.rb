class CreateMedicationPrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table  :medication_prescriptions, :primary_key => :prescription_id do |t|
    	t.integer    :drug_id
    	t.datetime   :start_date
    	t.datetime   :end_name
    	t.string     :instructions
    	t.boolean    :voided
    	t.integer    :voided_by, :limit=>8
    	t.datetime   :voided_date
    	t.string     :void_reason

      t.timestamps
    end
    add_foreign_key :medication_prescriptions, :encounters, column: 'encounter', primary_key: 'encounter_id'
  end
end
