class CreateDuplicateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :duplicate_statuses , :primary_key => :duplicate_statuses_id do |t|

      t.string  :status
      t.string  :description

      t.timestamps
    end

    change_column :duplicate_statuses, :duplicate_statuses_id, :integer
  end
end
