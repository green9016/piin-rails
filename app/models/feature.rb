# frozen_string_literal: true

class Feature < ApplicationRecord
  has_many :flags, dependent: :destroy
  has_many :firms, through: :flags

  validates :icon, :name, :description, presence: true
  validates :name, uniqueness: true
end
