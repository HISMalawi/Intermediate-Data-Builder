class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people, :primary_key => :person_id do |t|
      t.date         :birthdate, null:false
      t.boolean      :birthdate_est, null:false
      t.integer      :gender, null:false, :limit => 2
      t.date      	 :death_date
      t.boolean   	 :dead, null:false, default: 0
      t.boolean      :death_date_est, null:false
      t.boolean      :voided, null:false, default: 0
      t.bigint      :voided_by
      t.integer      :void_reason
      t.datetime	 :app_date_created, null:false
      t.datetime	 :app_date_updated, null:false

      t.timestamps
    end
    change_column :people, :person_id, :integer, limit: 8
  end
end
