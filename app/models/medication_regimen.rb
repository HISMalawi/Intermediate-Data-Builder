class MedicationRegimen < ApplicationRecord
	belongs_to :encounter
	belongs_to :medication_prescriptions_has_medication_regimen
end
