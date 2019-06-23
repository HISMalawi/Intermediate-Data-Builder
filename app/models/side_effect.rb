class SideEffect < ApplicationRecord
	belongs_to :encounter
	has_many   :side_effects_has_medication_prescription
end
