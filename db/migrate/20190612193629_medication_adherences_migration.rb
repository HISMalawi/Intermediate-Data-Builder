class MedicationAdherencesMigration < ActiveRecord::Migration[5.2]
  def change
<<<<<<< HEAD
    add_foreign_key :medication_adherences, :master_definitions, column: :drug_id, primary_key: :master_definition_id
    add_foreign_key :medication_adherences, :medication_dispensations, column: :medication_dispensation_id, primary_key: :medication_dispensation_id
=======
    add_foreign_key :medication_adherences, :master_definitions, column: :drug_id,
    				primary_key: :master_definition_id
    add_foreign_key :medication_adherences, :medication_dispensations,
    				column: :medication_dispensation_id, primary_key: :medication_dispensation_id
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  end
end
