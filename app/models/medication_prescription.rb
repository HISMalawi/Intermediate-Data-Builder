class MedicationPrescription < ApplicationRecord
	belongs_to :encounter
	has_many :medication_prescriptions_has_medication_regimen
end
