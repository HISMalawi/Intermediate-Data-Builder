class CreateMedicationRegimen < ActiveRecord::Migration[5.2]
  def change
    create_table    :medication_regimen, :primary_key => :regimen_id do |t|
    	t.integer     :encounter_id
    	t.string      :regimen 
    	t.boolean     :voided
    	t.integer     :voided_by
    	t.datetime    :voided_date
    	t.string      :void_reason

      t.timestamps
    end
  end
end
