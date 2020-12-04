# frozen_string_literal: true

class Trustee < ApplicationRecord
  include Discard::Model
  include HasActive

  enum role: %i[user admin]

  belongs_to :firm
  belongs_to :user

  validates :firm_id, uniqueness: { scope: :user_id }
  validates :role, :status, presence: true
end
