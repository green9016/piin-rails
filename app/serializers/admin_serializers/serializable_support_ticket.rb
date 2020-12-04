# frozen_string_literal: true

module AdminSerializers
  class SerializableSupportTicket < JSONAPI::Serializable::Resource
    type 'support_tickets'

    attributes :status, :created_at, :query, :checked

    belongs_to :ticketable
  end
end
