class BreastfeedingStatus < ApplicationRecord

	belongs_to :encounter
	belongs_to :user
	belongs_to :master_definition
end
