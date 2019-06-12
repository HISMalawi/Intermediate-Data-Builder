class CreateFamilyPlannings < ActiveRecord::Migration[5.2]
  def change
    create_table   :family_plannings , :primary_key => :family_planning_id do |t|
    	t.integer    :encounter_id
    	t.integer    :concept_id
    	t.integer    :value_coded
    	t.boolean    :voided
    	t.integer    :voided_by
    	t.datetime   :voided_date
    	t.string     :void_reason

      t.timestamps
    end
  end
end
