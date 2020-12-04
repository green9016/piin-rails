# frozen_string_literal: true

class SupportTicket < ApplicationRecord
  include Discard::Model
  include HasChecked

  enum status: %i[unread pending solved]

  belongs_to :ticketable, polymorphic: true

  validates :status, :query, presence: true
  validates :query, length: { maximum: 1500 }

  # TODO, what is this?
  ransacker :status, formatter: proc { |v| statuses[v] } do |parent|
    parent.table[:status]
  end
end
