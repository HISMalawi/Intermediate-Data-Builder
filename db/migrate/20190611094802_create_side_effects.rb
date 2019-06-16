class CreateSideEffects < ActiveRecord::Migration[5.2]
  def change
    create_table  :side_effects, :primary_key => :side_effect_id do |t|

      t.bigint  :encounter_id
      t.bigint  :concept_id
      t.bigint  :value_coded
      t.boolean :voided, null: false, default: 0
      t.bigint  :voided_by
      t.datetime  :voided_date
      t.string  :void_reason
      t.datetime	:app_date_created, null: false
      t.datetime	:app_date_updated, null: false

      t.timestamps
    end

    change_column :side_effects, :side_effect_id, :integer
  end
end
