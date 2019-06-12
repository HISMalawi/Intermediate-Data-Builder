class CreatePersonDetails < ActiveRecord::Migration[5.2]
  def change
    create_table       :person_details , :primary_key => :person_id do |t|
    	t.string       :given_name
    	t.string       :family_name
    	t.string       :middle_name
    	t.string       :maiden_name
    	t.datetime     :birthdate
    	t.boolean      :birthdate_estimated
    	t.string       :gender
    	t.string       :country_of_origin
    	t.string       :home_district
    	t.string       :home_ta
    	t.string       :home_village
    	t.boolean      :dead
    	t.datetime     :death_date
    	t.integer      :value_coded
    	t.boolean      :voided
    	t.integer      :voided_by
    	t.datetime     :voided_date
    	t.string       :void_reason
        
      t.timestamps
    end
  end
end
