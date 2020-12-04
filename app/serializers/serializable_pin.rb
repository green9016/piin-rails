# frozen_string_literal: true

class SerializablePin < JSONAPI::Serializable::Resource
  type 'pins'

  attributes :lat, :lng, :activated_on, :icon, :colour, :range, :title,
             :miles, :daily_price_in_cents, :pin_catalog_id,
             :pin_catalog_description, :consumed_balance,
             :consumed_days, :duration

  belongs_to :firm
  belongs_to :business
  belongs_to :pin_catalog

  attribute :photo do
    @object.pin_catalog.banner
  end

  attribute :banner do
    @object.pin_catalog.banner
  end

  attribute :is_draggable do
    # Pin is draggable until 30 min after its activation
    @object.activated_on.nil? || (Time.zone.now - @object.activated_on) / 60 <= 30
  end

  def percent_profile
     BusinessServices::ProfilePercentage.new(@object.business).call
  end

  meta do
    { business_profile_percent: percent_profile }
  end
end
