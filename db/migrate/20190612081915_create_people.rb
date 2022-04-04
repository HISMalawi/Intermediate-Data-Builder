# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people, primary_key: :person_id do |t|
      t.date :birthdate, null: false
      t.boolean :birthdate_est, null: false
      t.bigint  :gender, null: false
      t.date    :death_date
      t.bigint  :creator
      t.string  :cause_of_death
      t.datetime :voided_date
      t.boolean :dead, null: false, default: 0
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
    change_column :people, :person_id, :bigint
  end
end
