class SiteMigration < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :sites, :site_types, column: :site_type_id, primary_key: :site_type_id
  end
end
