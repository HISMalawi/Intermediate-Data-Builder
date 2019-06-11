class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, :primary_key => :user_id do |t|
    	t.string  :username
    	t.string  :password
    	t.integer :user_role
    	t.boolean :voided
    	t.integer :voided_by
    	t.datetime :voided_date
    	t.string  :void_reason
      t.timestamps
    end
  end
end
