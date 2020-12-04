# frozen_string_literal: true

class PinBalance < ApplicationRecord
  include Discard::Model

  belongs_to :pin, inverse_of: :pin_balance
  belongs_to :firm, inverse_of: :pin_balances

  validates :pin, :firm, :amount_in_cents, presence: true
end
