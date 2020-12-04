# frozen_string_literal: true

class SerializableFirmReport < JSONAPI::Serializable::Resource
  type 'firm_reports'

  attributes :month, :year, :total_spent_cents,
             :daily_spent_cents, :total_likes,
             :pins_purchased, :people_reached

  belongs_to :firm

  attribute :pin_catalogs_spent do
    pin_catalogs
  end

  def pin_catalogs
    pn = Rails.cache.fetch('pin_catalogs') do
      PinCatalog.all
    end

    pn.map do |pin_catalog|
      {
        title: pin_catalog.title,
        total_spent_in_cents: @object.total_pin_catalog_spent(pin_catalog),
        daily_spent_in_cents: @object.daily_pin_catalog_spent(pin_catalog)
      }
    end
  end
end
