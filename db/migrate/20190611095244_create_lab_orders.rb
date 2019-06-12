class CreateLabOrders < ActiveRecord::Migration[5.2]
  def change
    create_table    :lab_orders , :primary_key => :lab_order_id do |t|
    	t.string      :tracking_number
    	t.datetime    :order_date
    	t.integer     :encounter_id    	
    	t.integer     :value_coded
    	t.boolean     :voided
    	t.integer     :voided_by
    	t.datetime    :voided_date
    	t.string      :void_reason

      t.timestamps
    end
  end
end
