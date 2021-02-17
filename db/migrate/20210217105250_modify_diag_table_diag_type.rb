class ModifyDiagTableDiagType < ActiveRecord::Migration[5.2]
  def change
  	rename_column :diagnosis, :primary_diagnosis, :diagnosis
  	rename_column :diagnosis, :secondary_diagnosis, :diag_type
  end
end
