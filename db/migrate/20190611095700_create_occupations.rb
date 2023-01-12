# frozen_string_literal: true

class CreateOccupations < ActiveRecord::Migration[5.2]
  def change
    create_table :occupations, primary_key: :occupation_id do |t|
      t.bigint  :person_id, null: false
<<<<<<< HEAD
      t.bigint  :occupation, null: false
=======
      t.string  :occupation
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      t.bigint  :creator
      t.boolean :voided, null: false, default: 0
      t.integer :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end


