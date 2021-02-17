class CreateSoundexes < ActiveRecord::Migration[5.2]
  def change
    create_table :soundexes, primary_key: :person_id do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
    add_foreign_key :soundexes,:people, column: :person_id, primary_key: :person_id
  end
end
