class CreateDeIdentifiedIdentifiers < ActiveRecord::Migration[5.2]
  def change
    create_table     :de_identified_identifiers , :primary_key => :de_identified_identifier_id do |t|
    	t.string       :identifier
    	t.integer      :person_id
    	t.integer      :value_coded
    	t.boolean      :voided
    	t.integer      :voided_by
    	t.datetime     :voided_date
    	t.string       :void_reason

      t.timestamps
    end
  end
end
