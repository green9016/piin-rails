# frozen_string_literal: true

class SerializableSupportTicket < JSONAPI::Serializable::Resource
  type 'support_tickets'

  attributes :created_at, :query

  belongs_to :ticketable
end
