class CreateMasterDefinitions < ActiveRecord::Migration[5.2]
  def change
    create_table  :master_definitions, :primary_key => :master_definition_id do |t|

      t.string  :definition
      t.string  :description
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
