# frozen_string_literal: true

class CreateContactDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_details, primary_key: :person_id do |t|
      t.string  :home_phone_number
      t.string  :cell_phone_number
      t.string  :work_phone_number
      t.string  :email_address
      t.bigint  :creator, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
    change_column :contact_details, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    change_column :contact_details, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
  end
end
