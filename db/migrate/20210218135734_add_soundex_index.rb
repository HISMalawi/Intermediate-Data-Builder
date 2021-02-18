class AddSoundexIndex < ActiveRecord::Migration[5.2]
  def change
  	add_index :soundexes ,[:last_name, :first_name], name: 'soundex'
  end
end
