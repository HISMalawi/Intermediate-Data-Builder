class EncounterUuid < ActiveRecord::Migration[5.2]
  def change
  	add_column :encounters, :uuid, :binary, null: false
  end
end
