# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, primary_key: :user_id do |t|
      t.bigint  :person_id, null: false
      t.string  :username, null: false
      t.string  :password_digest
      t.integer :user_role, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
