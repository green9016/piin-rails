# frozen_string_literal: true

class Payment < ApplicationRecord
  include Discard::Model

  belongs_to :business
  belongs_to :firm
  belongs_to :pin

  validates :firm, :pin, :amount_in_cents, presence: true
end
