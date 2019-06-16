class CreateEncounters < ActiveRecord::Migration[5.2]
  def change
    create_table  :encounters, :primary_key => :encounter_id do |t|

      t.bigint  :encounter_type_id
      t.bigint  :program_id
      t.bigint  :person_id
      t.datetime  :visit_date
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime  :voided_date
      t.string  :void_reason
      t.bigint  :creator
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end