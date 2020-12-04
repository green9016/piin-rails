# frozen_string_literal: true

module AdminSerializers
  class SerializablePost < JSONAPI::Serializable::Resource
    type 'posts'

    attributes :title, :photo, :kinds, :status, :checked, :description,
               :color_code

    belongs_to :firm
    belongs_to :user
    has_many :offers
    has_many :users
    has_many :reports

    attribute :email do
      @object.business.email
    end

    attribute :active_since do
      @object.business.last_sign_in_at
    end

    def balance
      @total = 0
      pins = @object.pins
      pins.each do |pin|
        @total += pin.consumed_balance
      end
      @total
    end

    def total_daily_price_in_cents
      @total_daily_price_in_cents = 0
      pins = @object.pins
      pins.each do |pin|
        @total_daily_price_in_cents += pin.daily_price_in_cents
      end
      @total_daily_price_in_cents
    end

    meta do
      {
        reports_count: @object.reports.count,
        balance: balance,
        total: total_daily_price_in_cents,
        active_pins: [], # @object.pins.active,
        active_pins_count: @object.firm.pins.active.count,
        pins: [], # @object.pins,
        total_pins: @object.pins.count,
        like_count: @object.likes.count,
        posts_views: @object.views,
        posts_views_count: @object.views.count,
        view_count: @object.views.count
      }
    end
  end
end
