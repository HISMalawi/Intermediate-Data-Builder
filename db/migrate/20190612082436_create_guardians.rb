class CreateGuardians < ActiveRecord::Migration[5.2]
  def change
    create_table :guardians, :primary_key => :guardian_id do |t|
      t.integer      :person_id, null:false
      t.integer      :person_a, null:false
      t.integer      :person_b, null:false
      t.integer      :relationship_id, null:false
      t.boolean      :voided, null:false, default: 0
      t.integer      :voided_by
      t.integer      :void_reason
      t.datetime	 :app_date_created, null:false
      t.datetime	 :app_date_updated, null:false

      t.timestamps
    end

    add_foreign_key :guardians, :person, column: :person_id, primary_key: :person_id
    add_foreign_key :guardians, :relationships, column: :relationship_id, primary_key: :relationship_id
  end
end
