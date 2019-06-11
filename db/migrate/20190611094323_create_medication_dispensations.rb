class CreateMedicationDispensations < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_dispensations, :primary_key => :dispensation_id do |t|
    	t.integer  :prescription_id
    	t.float    :quantity
    	t.integer  :voided, :limit =>2
    	t.integer  :voided_by
    	t.datetime :voided_date
    	t.string   :void_reason

      t.timestamps
    end
  end
end
