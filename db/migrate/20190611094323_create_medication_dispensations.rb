class CreateMedicationDispensations < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_dispensations, :primary_key => :medication_dispensation_id do |t|
    	t.float          :quantity
      t.integer         :medication_prescription_id
      t.boolean    :voided, null: false, default: 0
      t.bigint        :voided_by
      t.datetime   :voided_date
      t.string       :void_reason

      t.timestamps
    end
      change_column :medication_dispensations, :medication_dispensation_id, :integer
  end

end
