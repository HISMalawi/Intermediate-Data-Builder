class CreateArvDrugs < ActiveRecord::Migration[5.2]
  def change
    create_table :arv_drugs do |t|
      t.integer :drug_id

      t.timestamps
    end
  end
end
