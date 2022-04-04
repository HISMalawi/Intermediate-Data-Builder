class AddIndexItechPotentialDuplicates < ActiveRecord::Migration[5.2]
  def change
    add_index :itech_potential_duplicates, [:duplicate_type,:person_a_id, :person_b_id], name: 'idx_itech_potential_duplicates'
  end
end
