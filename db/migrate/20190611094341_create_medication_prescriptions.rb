class CreateMedicationPrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table    :medication_prescriptions, :primary_key => :prescription_id do |t|
    	t.integer     :encounter_id
    	t.integer     :drug_id
    	t.datetime    :start_date
    	t.datetime    :end_name
    	t.string      :instructions
    	t.integer     :voided, :limit =>2
    	t.integer     :voided_by
    	t.datetime    :voided_date
    	t.string      :void_reason

      t.timestamps
    end
  end
end
