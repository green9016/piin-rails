# frozen_string_literal: true

class SerializableBusiness < JSONAPI::Serializable::Resource
  type 'businesses'

  attributes :email, :first_name, :last_name, :photo

  has_many :firms
  has_many :reports
  has_many :payments
end
