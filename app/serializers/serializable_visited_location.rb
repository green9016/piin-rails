# frozen_string_literal: true

class SerializableVisitedLocation < JSONAPI::Serializable::Resource
  type 'visited_locations'

  attributes :lat, :lng

  belongs_to :pin
  belongs_to :user
  belongs_to :post
end
