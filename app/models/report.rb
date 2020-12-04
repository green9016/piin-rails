# frozen_string_literal: true

class Report < ApplicationRecord
  include Discard::Model
  include HasActive
  include HasChecked

  belongs_to :user
  belongs_to :post
  has_one :firm, through: :post

  validates :description, presence: true

  # TODO, what is this?
  ransacker :status, formatter: proc { |v| statuses[v] } do |parent|
    parent.table[:status]
  end
end
