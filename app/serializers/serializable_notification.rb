# frozen_string_literal: true

class SerializableNotification < JSONAPI::Serializable::Resource
  type 'notification'

  attributes :name, :business, :description

  has_many :users

  attribute :unchecked_pins do
  end
end
