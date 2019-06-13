class DeIdentifiedIdentifiersMigration < ActiveRecord::Migration[5.2]
  def change
        add_foreign_key :de_identified_identifiers, :people, column: :person_id, primary_key: :person_id
  end
end
