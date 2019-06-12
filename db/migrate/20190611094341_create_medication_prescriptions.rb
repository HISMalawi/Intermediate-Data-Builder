class CreateMedicationPrescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table  :medication_prescriptions, :primary_key => :medication_prescription_id do |t|
    	t.integer    :drug_id
      t.bigint      :encounter_id
    	t.datetime   :start_date
    	t.datetime   :end_name
    	t.string        :instructions
    	t.boolean    :voided, null: false, default: 0
    	t.bigint        :voided_by
    	t.datetime   :voided_date
    	t.string       :void_reason

      t.timestamps
    end
    end
    def up
      add_foreign_key :medication_prescriptions, :encounters, column: :encounter_id, primary_key: :encounter_id
      add_foreign_key :medication_prescriptions, :master_definitions, column: :drug_id, primary_key: :master_definition_id
    end
end
