class PotentialDuplicates < ApplicationRecord
	belongs_to :person_detail
	has_many   :duplicate_status

end
