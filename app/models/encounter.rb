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
  has_many :medication_adherence
  has_many :pregnant_status
  has_many :medication_prescription
end
