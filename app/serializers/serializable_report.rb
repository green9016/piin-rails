# frozen_string_literal: true

class SerializableReport < JSONAPI::Serializable::Resource
  type 'reports'

  attributes :description, :wrong_location, :false_offers,
             :incorrect_open_hours, :wrong_phone_number,
             :different_business_name, :other_reason

  belongs_to :user
  belongs_to :post

  meta do
    {}
  end
end
