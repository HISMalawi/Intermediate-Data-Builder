class CreatePotentialDuplicates < ActiveRecord::Migration[5.2]
  def change
    create_table  :potential_duplicates, :primary_key => :potential_duplicate_id do |t|

      t.bigint :person_id_a, null: false
      t.bigint :person_id_b, null: false
      t.bigint  :duplicate_status_id
      t.float  :score, null: false
      t.boolean  :voided, null: false, default: 0
      t.bigint :voided_by
      t.datetime :voided_date
      t.string :void_reason

      t.timestamps
    end
  end
end