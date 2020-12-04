# frozen_string_literal: true

module AdminSerializers
  class SerializableBusiness < JSONAPI::Serializable::Resource
    type 'businesses'

    attributes :username, :email, :first_name, :last_name, :birthday, :status,
               :created_at, :photo, :last_sign_in_at, :blocked

    has_many :pins
    has_many :posts
    has_many :firms
    has_many :reports
    has_many :payments
    has_many :support_tickets, polymorphic: true
    has_one :owned_firm

    attribute :balance do
      return 0 unless @object.owned_firm

      @object.owned_firm.available_balance
    end
  end
end
