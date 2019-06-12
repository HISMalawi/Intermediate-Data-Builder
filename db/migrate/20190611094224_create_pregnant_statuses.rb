class CreatePregnantStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :pregnant_statuses, :primary_key => :pregnant_status_id do |t|
     	t.integer    :concept_id
    	t.integer    :value_coded
    	t.boolean    :voided
    	t.integer    :voided_by, :limit =>8
    	t.datetime   :voided_date
    	t.string     :void_reason

      t.timestamps
    end
    add_foreign_key :pregnant_statuses, :encounters, column: 'encounter', primary_key: 'encounter_id'
  end
end
