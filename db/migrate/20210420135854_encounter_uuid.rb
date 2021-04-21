class EncounterUuid < ActiveRecord::Migration[5.2]
  def change
  	add_column :encounters, :uuid, :binary, :limit => 36, null: false, uniq: true
  end
end
