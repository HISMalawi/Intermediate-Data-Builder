class Soundex < ApplicationRecord
	belongs_to :de_duplicator, foreign_key: :person_id, primary_key: :person_id
end
