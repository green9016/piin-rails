# frozen_string_literal: true

class SerializableFeature < JSONAPI::Serializable::Resource
  type 'features'

  attributes :name, :icon, :description

  has_many :firms
end
