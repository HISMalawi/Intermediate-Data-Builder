class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table      :users, :primary_key => :user_id do |t|
          t.bigint       :person_id
          t.string       :username
          t.string       :password
          t.integer     :user_role
          t.boolean    :voided, null: false, default: 0
          t.integer     :voided_by
          t.datetime   :voided_date
          t.string       :void_reason

           t.timestamps
    end
         add_foreign_key :users, :person, column: :person_id, primary_key: :person_id
  end
end
