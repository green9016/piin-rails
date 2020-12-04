# frozen_string_literal: true

class Alert < ApplicationRecord
  include Discard::Model

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  belongs_to :notification
  belongs_to :user

  validates :notification_id, uniqueness: { scope: :user_id }
end
