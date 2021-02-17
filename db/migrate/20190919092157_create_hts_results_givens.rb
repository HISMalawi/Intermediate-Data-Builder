class CreateHtsResultsGivens < ActiveRecord::Migration[5.2]
  def change
    create_table :hts_results_givens, primary_key: :htsrg_id do |t|
      t.bigint  :encounter_id
      t.bigint  :concept_id
      t.bigint  :value_coded
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime :voided_date
      t.string   :void_reason
      t.bigint   :creator
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
    add_foreign_key :hts_results_givens, :encounters, column: :encounter_id, primary_key: :encounter_id
  end
end
