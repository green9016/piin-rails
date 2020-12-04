# frozen_string_literal: true

class View < ApplicationRecord
  include Discard::Model

  belongs_to :user
  belongs_to :post

  validates :user, :post, presence: true
end
