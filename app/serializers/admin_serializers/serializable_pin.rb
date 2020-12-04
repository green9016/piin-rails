# frozen_string_literal: true

module AdminSerializers
  class SerializablePin < JSONAPI::Serializable::Resource
    type 'pins'

    attributes :status, :lat, :lng, :icon, :colour, :range, :duration, :daily_price_in_cents,
               :title, :checked, :activated_on

    belongs_to :firm
    has_many :users
    has_many :offers
    belongs_to :user

    attribute :email do
      @object.business.email
    end

    attribute :active_since do
      @object.business.last_sign_in_at
    end

    attribute :photo do
      @object.firm.photo
    end

    def pins_from_pin_catalog
      Pin&.where(pin_catalog_id: @object.pin_catalog_id)
    end

    def total_revenue
      @total = 0
      return @total if @object.nil?

      total_pins = Pin.where(pin_catalog_id: @object.pin_catalog_id)
      total_pins.each do |pin|
        @total += pin.remaining_balance
      end
      @total
    end

    meta do
      # TODO, disabling most of these values, because they break everything
      {
        reports_count: 0,# @object.firm.reports_count,
        posts_count: 0,# @object.firm.posts.count,
        pins_count: 0,# Pin.all.count,
        balance: 0,# @object.consumed_balance,
        total: 0,# @object.daily_price_in_cents,
        active_pins: [], # TODO, what is this?
        active_pins_count: 0,# Pin.active.count,
        stripe_transaction_id: 'stripe_transaction_id', # TODO: don't know value
        reach_count: 55, # TODO: don't know the value
        likes_count: 40, # TODO: don't know the value
        user_views_count: 0,# @object.visited_locations.count,
        business_usage_count: 0,# pins_from_pin_catalog.count,
        total_revenue: 0,# total_revenue,
        posts: [],# @object.firm.posts
      }
    end
  end
end
