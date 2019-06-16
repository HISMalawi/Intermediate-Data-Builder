class CreateOutcomes < ActiveRecord::Migration[5.2]
  def change
    create_table :outcomes, :primary_key => :outcome_id, force: :cascade do |t|

      t.bigint  :encounter_id
      t.bigint  :concept_id
      t.string  :outcome_reason
      t.string  :outcome_source
      t.bigint  :value_coded
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime  :voided_date
      t.string  :void_reason
      t.datetime	:app_date_created, null: false
      t.datetime	:app_date_updated, null: false

      t.timestamps
    end
  end
end
