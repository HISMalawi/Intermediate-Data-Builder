class CreateMedicationAdherences < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_adherences, :primary_key => :adherence_id do |t|
    	t.integer    :medication_dispensation_id
      t.bigint      :drug_id
    	t.float        :adherence
      t.boolean    :voided, null: false, default: 0
      t.bigint        :voided_by
      t.datetime   :voided_date
      t.string       :void_reason 	

      t.timestamps
    end
    end
    def up
      add_foreign_key :medication_adherences, :master_definitions, column: :drug_id, primary_key: :master_definition_id
      add_foreign_key :medication_adherences, :medication_dispensations, column: :medication_dispensation_id, primary_key: :medication_dispensation_id
    end

end