class CreateMedicationDispensations < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_dispensations, :primary_key => :dispensation_id do |t|
    	t.float      :quantity
    	t.boolean    :voided
    	t.integer    :voided_by
    	t.datetime   :voided_date
    	t.string     :void_reason

      t.timestamps
    end
    add_foreign_key :medication_dispensations, :prescription, column: 'prescription', primary_key: 'prescription_id'
  end
end
