class LabTestResult < ApplicationRecord
	has_many :lab_orders
	has_many :master_definition
end
