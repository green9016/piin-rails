# frozen_string_literal: true

module AdminSerializers
  class SerializablePinCatalog < JSONAPI::Serializable::Resource
    type 'pin_catalogs'

    attributes :title, :description, :banner,
               :icon, :color, :miles, :range, :duration_in_days

    has_many :pins
  end
end
