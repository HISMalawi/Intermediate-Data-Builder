class ProvidersMigration < ActiveRecord::Migration[5.2]
  def change
  		add_foreign_key :providers, :person_names, column: :person_name_id, primary_key: :person_name_id
       	add_foreign_key :providers, :person_types, column: :person_type_id, primary_key: :person_type_id
  end
end
