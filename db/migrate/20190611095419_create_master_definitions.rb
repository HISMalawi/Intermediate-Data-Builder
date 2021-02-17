# frozen_string_literal: true

class CreateMasterDefinitions < ActiveRecord::Migration[5.2]
  def change
    create_table :master_definitions, primary_key: :master_definition_id do |t|
      t.string :definition, null: false
      t.text :description
      t.integer :openmrs_metadata_id, null: false
      t.string :openmrs_entity_name, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string :void_reason

      t.timestamps
    end
    add_index :master_definitions, :openmrs_metadata_id
    add_index :master_definitions, :openmrs_entity_name, type: :fulltext
  end
end
