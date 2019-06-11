class LabOrder < ApplicationRecord
	belongs_to :encounters
	belongs_to :lab_test_result
end
