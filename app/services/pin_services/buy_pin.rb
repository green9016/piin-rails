# frozen_string_literal: true

module PinServices
  class BuyPin
    attr_reader :pin

    def initialize(business, pin_catalog)
      @business = business
      @pin_catalog = pin_catalog

      @pin = nil
    end

    def call
      # TODO, must check if the Firm has all attributes set correctly

      @pin = @business.pins.new(pin_attributes)

      ActiveRecord::Base.transaction do
        @pin.save!

        @amount_to_charge = apply_credits(@pin, @pin.firm)
        @charge = charge_business(@pin.business, @amount_to_charge)
      end

      # TODO, create if paid only with credits?
      create_payment!
    rescue Stripe::CardError => e
      raise PaymentException, e.message
    end

    private

    def pin_attributes
      # TODO, rename "colour" to "color"
      { firm: @business.owned_firm, pin_catalog: @pin_catalog,
        icon: @pin_catalog.icon, colour: @pin_catalog.color,
        range: @pin_catalog.range, duration: @pin_catalog.duration_in_days,
        miles: @pin_catalog.miles,
        daily_price_in_cents: @pin_catalog.daily_price_in_cents,
        initial_balance_in_cents: @pin_catalog.daily_price_in_cents *
          @pin_catalog.duration_in_days,
        lat: 0, lng: 0 }
    end

    def apply_credits(pin, firm)
      return pin.initial_balance_in_cents unless
        firm.available_balance.positive?

      credits = [firm.available_balance, pin.initial_balance_in_cents].min

      firm.pin_balances.create!(pin: pin, amount_in_cents: -credits)

      pin.initial_balance_in_cents - credits
    end

    def charge_business(business, amount)
      return unless amount.positive?

      PaymentServices::ChargeBusiness.new(business, amount).call
    end

    def create_payment!
      return unless @amount_to_charge.positive?

      Payment.create!(firm: @pin.firm, business: @pin.business, pin: @pin,
                      amount_in_cents: @amount_to_charge,
                      stripe_charge_id: @charge.id)
    end
  end
end
