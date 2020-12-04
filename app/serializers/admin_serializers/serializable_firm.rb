# frozen_string_literal: true

module AdminSerializers
  class SerializableFirm < JSONAPI::Serializable::Resource
    type 'firms'

    attributes :name, :photo, :about,
               :state, :city, :street, :zip, :lat,
               :lng, :status, :checked, :business_type, :phone_number, :website

    attribute :email do
      @object&.owner&.email
    end

    attribute :active_since do
      @object&.owner&.last_sign_in_at
    end

    has_many :features
    has_many :schedules
    has_many :posts
    has_many :users
    has_many :pins
    has_many :purchases
    belongs_to :owner

    meta do
      { reports_count: @object&.reports_count,
        active_pins_count: @object&.active_pins_count,
        balance: 0, # TODO
        hashtags: [], # TODO
        total_spent: 1.2, # TODO: don't know the value }
        total: Firm.count,
        posts_count: @object&.posts&.count }
    end
  end
end
