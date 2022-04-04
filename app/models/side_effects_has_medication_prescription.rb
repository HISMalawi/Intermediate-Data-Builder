class SideEffectsHasMedicationPrescription < ApplicationRecord
	has_many :side_effect
	has_many :medical_prescription
end
