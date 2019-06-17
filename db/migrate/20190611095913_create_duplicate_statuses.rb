# frozen_string_literal: true

class CreateDuplicateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :duplicate_statuses, primary_key: :duplicate_status_id do |t|
      t.string  :status
      t.string  :description

      t.timestamps
    end
    change_column :duplicate_statuses, :duplicate_status_id, :integer,  auto_increment: true
  end
end
