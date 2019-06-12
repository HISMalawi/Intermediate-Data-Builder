class CreateDiagnoses < ActiveRecord::Migration[5.2]
  def change
    create_table   :diagnoses, :primary_key => :diagnosis_id do |t|
    	t.integer    :encounter_id
    	t.integer    :primary_diagnosis, :limit => 2
    	t.integer    :concept_id
    	t.integer    :voided, :limit =>2
    	t.integer    :voided_by
    	t.datetime   :voided_date
    	t.string     :void_reason

      t.timestamps
    end
  end
end
