class MedicationDispensationsMigration < ActiveRecord::Migration[5.2]
  def change
      add_foreign_key :medication_dispensations, :medication_prescriptions, column: :medication_prescription_id, primary_key: :medication_prescription_id
  end
end
