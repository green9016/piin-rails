# frozen_string_literal: true

class Location < ApplicationRecord
  include Discard::Model

  belongs_to :user

  validates :lat, :lng, presence: true
end
