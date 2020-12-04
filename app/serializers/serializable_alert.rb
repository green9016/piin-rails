# frozen_string_literal: true

class SerializableAlert < JSONAPI::Serializable::Resource
  type 'alerts'

  attributes :active

  belongs_to :notification
  belongs_to :user
end
