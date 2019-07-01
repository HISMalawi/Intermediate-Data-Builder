class AddDrugCompositionToMedicationRegimen < ActiveRecord::Migration[5.2]
  def change
    add_column :medication_regimen, :drug_composition, :string
  end
end
