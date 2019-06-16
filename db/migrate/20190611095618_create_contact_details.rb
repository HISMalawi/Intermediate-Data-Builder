class CreateContactDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_details , :primary_key => :contact_details_id do |t|

      t.bigint  :person_id, null: false
      t.string  :home_phone_number
      t.string  :cell_phone_number
      t.string  :work_phone_number
      t.string  :email_address
      t.bigint  :creator, null: false
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime  :voided_date
      t.string  :void_reason
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
