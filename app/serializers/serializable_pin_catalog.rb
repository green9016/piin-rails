# frozen_string_literal: true

class SerializablePinCatalog < JSONAPI::Serializable::Resource
  type 'pin_catalogs'

  attributes :title, :description, :banner,
             :icon, :color, :miles, :range, :duration_in_days,
             :daily_price_in_cents, :status

  has_many :pins

  attribute :price do
    @object.daily_price_in_cents * @object.duration_in_days
  end

  def status
    PinCatalog.statuses[@object.status.to_sym]
  end

  meta do
    { users_views: @object.views.count,
      first_time_used: @object.pins.first&.created_at,
      business_usage: @object.pins.count,
      total_revenue: @object.payments.sum(&:amount_in_cents) }
  end
end
