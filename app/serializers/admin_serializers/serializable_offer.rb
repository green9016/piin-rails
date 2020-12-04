# frozen_string_literal: true

module AdminSerializers
  class SerializableOffer < JSONAPI::Serializable::Resource
    type 'offers'

    attributes :title, :price, :percent, :start_time, :end_time, :formatted_week_days, :status

    belongs_to :post

    meta do
      {}
    end
  end
end
