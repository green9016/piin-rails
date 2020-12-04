# frozen_string_literal: true

class Notification < ApplicationRecord
  has_many :alerts, dependent: :destroy
  has_many :users, through: :alerts

  validates :name, :description, :business, presence: true
  validates :name, uniqueness: true
end
