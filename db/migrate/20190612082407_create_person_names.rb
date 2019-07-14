# frozen_string_literal: true

class CreatePersonNames < ActiveRecord::Migration[5.2]
  def change
    create_table :person_names, primary_key: :person_name_id do |t|
      t.bigint  :person_id, null: false
      t.string  :given_name
      t.string  :family_name
      t.string  :middle_name
      t.string  :maiden_name
      t.bigint  :creator, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint :voided_by
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
    change_column :person_names, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    change_column :person_names, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
  end
end
