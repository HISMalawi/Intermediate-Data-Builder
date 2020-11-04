class CreateIdentifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :identifiers, primary_key: :patient_identifier_id do |t|
     t.bigint :patient_identifier_id, null: false
     t.bigint :person_id, null: false
     t.string :identifier, null: false
     t.integer :identifier_type, null: false
     t.bigint :creator, null: false
     t.boolean :voided, null: false, default: 0
     t.bigint    :voided_by
     t.bigint    :creator, null: false
     t.datetime  :voided_date
     t.string :void_reason
     t.datetime :app_date_created
     t.datetime :app_date_updated

     t.timestamps
    end
  end
end
