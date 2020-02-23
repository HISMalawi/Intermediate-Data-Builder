class AddUniqueIndexForDeidentifiedIdentifier < ActiveRecord::Migration[5.2]
  def change
  	add_index :de_identified_identifiers, :identifier, unique: true
  end
end
