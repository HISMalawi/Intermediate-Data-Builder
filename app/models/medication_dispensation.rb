class MedicationDispensation < ApplicationRecord
  belongs_to  :medication_prescription
end
