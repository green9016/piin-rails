# frozen_string_literal: true

class Order < ApplicationRecord
  include Discard::Model
  include HasActive

  belongs_to :firm
  belongs_to :user

  validates :code, :value, :stripe_charge_token, :stripe_charge_status,
            :status, presence: true
  validates :code, :stripe_charge_token, uniqueness: true
end
