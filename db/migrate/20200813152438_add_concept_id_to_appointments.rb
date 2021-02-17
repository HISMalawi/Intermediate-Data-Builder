class AddConceptIdToAppointments < ActiveRecord::Migration[5.2]
  def change
  	add_column :appointments, :concept_id, :integer
  end
end
