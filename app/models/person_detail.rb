class PersonDetail < ApplicationRecord
	has_many :current_address
	has_many :occupation
	has_many :ralationships
	has_many :potential_duplicates
	has_many :contact_details
	has_many :encounters
end
