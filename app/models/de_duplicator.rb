class DeDuplicator < ApplicationRecord
	has_one :soundex, foreign_key: :person_id, primary_key: :person_id
end
