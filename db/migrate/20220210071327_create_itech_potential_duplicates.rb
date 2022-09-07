class CreateItechPotentialDuplicates < ActiveRecord::Migration[5.2]
  def change
    create_table :itech_potential_duplicates do |t|
      t.bigint :person_a_id, null: false
      t.bigint :person_b_id, null: false
      t.float :score, null: false
      t.string :duplicate_type, null: false

      t.timestamps
    end
  end
end
