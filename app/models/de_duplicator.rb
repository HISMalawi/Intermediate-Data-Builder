class DeDuplicator < ApplicationRecord
<<<<<<< HEAD
=======
	has_one :soundex, foreign_key: :person_id, primary_key: :person_id
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
end
