class CreateDeIdentifiedIdentifiers < ActiveRecord::Migration[5.2]
  def change
    create_table     :de_identified_identifiers , :primary_key => :de_identified_identifier_id do |t|
    	t.string          :identifier
    	t.bigint          :person_id
    	t.boolean       :voided, null: false, default: 0
    	t.integer        :voided_by
    	t.datetime      :voided_date
    	t.string          :void_reason

      t.timestamps
    end
        add_foreign_key :de_identified_identifiers, :people, column: :person_id, primary_key: :person_id
  end
end
