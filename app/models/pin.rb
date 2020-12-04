# frozen_string_literal: true

# TODO, Pins and PinCatalogs have border width and border color

class Pin < ApplicationRecord
  include Discard::Model
  include HasActive

  scope :not_activated, -> { where(activated_on: nil) }
  scope :can_activate, -> { where('activated_on is NULL OR activated_on >= :time_limit', time_limit: Time.zone.now - 30.minutes) }

  belongs_to :pin_catalog, inverse_of: :pins
  belongs_to :firm
  belongs_to :business

  # has_many :views, class_name: 'View', dependent: :destroy
  has_many :visited_locations, -> { merge(VisitedLocation.kept) }, inverse_of: :pin, dependent: :destroy
  has_many :users, through: :visited_locations
  has_many :payments, -> { merge(Payment.kept) }, inverse_of: :pin, dependent: :destroy
  has_many :offers, through: :firm
  has_one :pin_balance, inverse_of: :pin

  delegate :description, to: :pin_catalog, prefix: true

  validates :firm, :business, :pin_catalog, presence: true
  validates :icon, :colour, :range, :duration, :daily_price_in_cents,
            :lat, :lng, :status, presence: true

  def remaining_balance
    initial_balance_in_cents - consumed_balance
  rescue StandardError
    0
  end

  def consumed_balance
    consumed_days * daily_price_in_cents
  end

  def consumed_days
    return 0 unless activated_on?

    # adding 1 because the day is paid in advance
    # ie: when the Pin is activated, it already consumes the 1st day
    ((Time.zone.now - activated_on) / 1.day).to_i + 1
  end

  def discard_pin
    discard
    visited_locations.each(&:discard)
    purchases.each(&:discard)
    true
  end
end
