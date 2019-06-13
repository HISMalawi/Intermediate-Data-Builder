class CreateTbStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table    :tb_statuses, :primary_key => :tb_status_id do |t|
      t.bigint        :encounter_id
      t.integer       :concept_id
      t.integer       :value_coded
      t.boolean     :voided, null: false, default: 0
      t.bigint        :voided_by
      t.datetime    :voided_date
      t.string         :void_reason

      t.timestamps
    end
  end
end

