class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table   :relationships, :primary_key => :relationship_id do |t|
    	t.bigint       :person_id_a, null:false
    	t.bigint       :person_id_b, null:false
    	t.integer      :relationship_type_id, null:false
      t.bigint       :creator, null:false
    	t.boolean      :voided, null: false, default: 0
    	t.bigint       :voided_by
    	t.datetime     :voided_date
    	t.string       :void_reason
      t.datetime     :app_date_created, null:false
      t.datetime     :app_date_updated, null:false

      t.timestamps
    end
  end
  def up
    add_foreign_key :relationships, :people, column: :person_id_a, primary_key: :person_id
    add_foreign_key :relationships, :people, column: :person_id_b, primary_key: :person_id
  end
end
  