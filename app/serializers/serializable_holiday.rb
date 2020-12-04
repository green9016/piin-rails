# frozen_string_literal: true

class SerializableHoliday < JSONAPI::Serializable::Resource
  type 'holidays'

  attributes :title, :post_photo, :icon_photo, :from_date, :until_date, :status

  attribute :photo do
    @object.post_photo
  end
end
