# frozen_string_literal: true

class LikeDislike < ApplicationRecord
  include Discard::Model

  belongs_to :user
  belongs_to :post

  validates :post_id, uniqueness: { scope: :user_id }

  scope :like, -> { where(is_like: true) }
  scope :dislike, -> { where(is_like: false) }
end
