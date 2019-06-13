class CreateGuardians < ActiveRecord::Migration[5.2]
  def change
    create_table :guardians, :primary_key => :guardian_id do |t|

      t.bigint  :person_id, null: false
      t.bigint  :person_a, null: false
      t.bigint  :person_b, null: false
      t.bigint  :relationship_type_id, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint  :creator
      t.bigint  :voided_by
      t.integer :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated, null: false

      t.timestamps
    end
  end
end
