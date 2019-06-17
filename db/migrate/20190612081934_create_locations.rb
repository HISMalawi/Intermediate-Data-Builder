# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations, primary_key: :location_id do |t|
      t.string :name, null: false
      t.integer :parent_location
      t.string  :description
      t.string  :latitude
      t.string  :longitude
      t.boolean :voided, null: false, default: 0
      t.bigint :voided_by
      t.integer :void_reason

      t.timestamps
    end
		change_column :locations, :location_id, :integer,  auto_increment: true
	end
end
