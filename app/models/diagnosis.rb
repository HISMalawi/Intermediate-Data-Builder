# frozen_string_literal: true

class Diagnosis < ApplicationRecord
  self.table_name = 'diagnosis'
  belongs_to :encounter
end
