# frozen_string_literal: true

class CreateVitals < ActiveRecord::Migration[5.2]
  def change
    create_table :vitals, primary_key: :vitals_id do |t|
      t.bigint  :encounter_id
      t.bigint  :concept_id
      t.bigint  :value_coded
      t.bigint  :value_numeric
<<<<<<< HEAD
      t.bigint  :value_text
      t.bigint  :value_modifier
=======
      t.string  :value_text
      t.string  :value_modifier
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      t.bigint  :value_min
      t.bigint  :value_max
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
