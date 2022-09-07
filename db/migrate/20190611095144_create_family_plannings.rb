# frozen_string_literal: true

class CreateFamilyPlannings < ActiveRecord::Migration[5.2]
  def change
    create_table :family_plannings, primary_key: :family_planning_id do |t|
      t.bigint  :encounter_id
      t.bigint  :concept_id
      t.bigint  :value_coded
      t.boolean :voided, null: false, default: 0
      t.bigint :voided_by
      t.datetime :voided_date
      t.string :void_reason
<<<<<<< HEAD
=======
      t.bigint :creator
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
      t.datetime  :app_date_created, null: false
      t.datetime  :app_date_updated

      t.timestamps
    end
  end
end
