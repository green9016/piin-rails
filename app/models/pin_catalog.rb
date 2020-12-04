# frozen_string_literal: true

class PinCatalog < ApplicationRecord
  include Discard::Model
  include HasActive

  has_many :pins, inverse_of: :pin_catalog
  has_many :firms, through: :pins
  has_many :payments, through: :pins
  has_many :users, through: :pins
  has_many :views, through: :users

  validates :title, :description, :banner, :icon, :color, :miles, :range,
            :duration_in_days, :daily_price_in_cents, presence: true

  mount_base64_uploader :banner, PhotoUploader
  mount_base64_uploader :icon, PhotoUploader
end
