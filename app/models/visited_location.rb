# frozen_string_literal: true

class VisitedLocation < ApplicationRecord
  include Discard::Model

  scope :unseen, -> { where(seen_at: nil) } 

  belongs_to :pin
  belongs_to :user

  validates :pin, :user, :lat, :lng, presence: true

  def post
    pin.firm.posts.order('RANDOM()').first
  end
end
