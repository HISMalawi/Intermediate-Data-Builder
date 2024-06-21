# frozen_string_literal: true

class Encounter < ApplicationRecord
  has_many :presenting_complaint
  has_many :vitals
  has_many :side_effect
  has_many :diagnosis
  has_many :tb_status
  has_many :outcome
  has_many :symptoms
  has_many :hiv_staging_info
  has_many :medication_regimen
  has_many :breastfeeding_status
  has_many :pregnant_status
<<<<<<< HEAD
=======
  has_many :family_planning
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
end
