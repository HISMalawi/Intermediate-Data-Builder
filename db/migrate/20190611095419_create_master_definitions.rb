class CreateMasterDefinitions < ActiveRecord::Migration[5.2]
  def change
    create_table   :master_definitions, :primary_key => :master_def_id do |t|
          t.string    :definition
          t.string     :description
          t.integer   :value_coded
          t.boolean   :voided, null: false, default: 0
          t.integer    :voided_by
          t.datetime   :voided_date
          t.string     :void_reason

      t.timestamps
    end
  end
end
