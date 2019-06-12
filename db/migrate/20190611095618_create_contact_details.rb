class CreateContactDetails < ActiveRecord::Migration[5.2]
  def change
    create_table    :contact_details , :primary_key => :contact_details_id do |t|
        t.bigint        :person_id
        t.string        :home_phone_number
        t.string        :cell_phone_number
        t.string        :work_phone_number
        t.string        :email_address
        t.bigint        :creator
        t.boolean      :voided, null: false, default: 0
        t.integer      :voided_by
        t.datetime    :voided_date
        t.string        :void_reason

        t.timestamps
    end
       add_foreign_key :contact_details, :people, column: :person_id, primary_key: :person_id
  end
end
