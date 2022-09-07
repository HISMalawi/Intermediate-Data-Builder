class RemoveNotNullConstraintFromIdentifiers < ActiveRecord::Migration[5.2]
  def change
  	change_column :identifiers, :identifier, :string, null: true
  end
end
