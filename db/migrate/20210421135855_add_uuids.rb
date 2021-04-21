class AddUuids < ActiveRecord::Migration[5.2]
  def change
  	add_column :people, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :person_names, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :person_addresses, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :relationships, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :users, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :identifiers, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :outcomes, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :breastfeeding_statuses, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :diagnosis, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :appointments, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :pregnant_statuses, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :patient_histories, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :family_plannings, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :presenting_complaints, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :lab_orders, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :vitals, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :symptoms, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :tb_statuses, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :hts_results_givens, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :medication_prescriptions, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :medication_dispensations, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :medication_adherences, :uuid, :binary, :limit => 36, null: false, uniq: true
  	add_column :side_effects, :uuid, :binary, :limit => 36, null: false, uniq: true
  end
end
