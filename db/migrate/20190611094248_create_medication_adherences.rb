class CreateMedicationAdherences < ActiveRecord::Migration[5.2]
  def change
    create_table    :medication_adherences, :primary_key => :adherence_id do |t|

    	t.integer     :encounter_id
    	t.integer     :drug_id
    	t.float       :adherence
    	t.integer     :voided, :limit =>2
    	t.integer     :voided_by
    	t.datetime    :voided_date
    	t.string      :void_reason    	

      t.timestamps
    end
  end
end
