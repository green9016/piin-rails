# frozen_string_literal: true

class SerializableFirm < JSONAPI::Serializable::Resource
  type 'firms'

  attributes :name, :photo, :about, :state, :city, :street, :zip, :lat, :lng,
             :business_type, :phone_number, :website

  attribute :email do
    @object&.owner&.email
  end

  has_many :features
  has_many :schedules
  has_many :posts
  belongs_to :owner

  meta do
    {}
  end
end
