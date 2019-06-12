class CreateOutcomes < ActiveRecord::Migration[5.2]
  def change
    create_table    :outcomes, :primary_key => :outcome_id, force: :cascade do |t|
      t.integer     :encounter_id
      t.integer     :concept_id
      t.string        :outcome_reason
      t.string        :outcome_source
      t.integer     :value_coded
      t.boolean     :voided, null: false, default: 0
      t.bigint        :voided_by
      t.datetime    :voided_date
      t.string         :void_reason

      t.timestamps
    end
  end 
end
