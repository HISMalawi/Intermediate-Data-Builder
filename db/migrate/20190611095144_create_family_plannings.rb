class CreateFamilyPlannings < ActiveRecord::Migration[5.2]
  def change
    create_table   :family_plannings , :primary_key => :family_planning_id do |t|
    	t.integer      :encounter_id
    	t.integer      :concept_id
    	t.integer      :value_coded
    	t.boolean    :voided, null: false, default: 0
    	t.bigint       :voided_by
    	t.datetime   :voided_date
    	t.string       :void_reason

      t.timestamps
    end
  end
  def up
        add_foreign_key :lab_orders, :encounters, column: :encounter_id, primary_key: :encounter_id
        add_foreign_key :lab_orders, :master_definitions, column: :concept_id, primary_key: :master_definition_id
  end
end
