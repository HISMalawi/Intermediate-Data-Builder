class MedicationPrescriptionHasMedicationRegimen < ApplicationRecord
	has_many :medical_prescription
	has_many :medical_regimen
end
