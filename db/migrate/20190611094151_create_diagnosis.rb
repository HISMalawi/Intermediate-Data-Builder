class CreateDiagnosis < ActiveRecord::Migration[5.2]
  def change
    create_table :diagnosis, :primary_key => :diagnosis_id do |t|
    	t.bigint    :encounter_id
      t.bigint    :concept_id
    	t.boolean    :primary_diagnosis
      t.boolean    :secondary_diagnosis
      t.boolean   :voided, null: false, default: 0
      t.bigint       :voided_by
      t.datetime   :voided_date
      t.string       :void_reason

      t.timestamps
      end
    end
end
