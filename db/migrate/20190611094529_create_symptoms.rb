class CreateSymptoms < ActiveRecord::Migration[5.2]
  def change
    create_table :symptoms, :primary_key => :symptom_id do |t|
    	t.integer :encounter_id
    	t.integer :concept_id
    	t.integer :value_coded
    	t.integer :voided, :limit =>2
    	t.integer :voided_by
    	t.datetime :voided_date
    	t.string  :void_reason

      t.timestamps
    end
  end
end
