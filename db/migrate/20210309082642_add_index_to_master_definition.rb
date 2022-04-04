class AddIndexToMasterDefinition < ActiveRecord::Migration[5.2]
  def change
  	add_index :master_definitions, [:openmrs_entity_name, :openmrs_metadata_id], name: 'patient_identifiers'
  	add_index :identifiers, :patient_identifier_id, name: 'patient_identifier_index'
  end
end
