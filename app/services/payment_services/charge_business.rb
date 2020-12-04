# frozen_string_literal: true

module PaymentServices
  class ChargeBusiness
    def initialize(business, amount_in_cents)
      @business = business
      @amount_in_cents = amount_in_cents
    end

    def call
      Stripe::Charge.create(
        amount: @amount_in_cents,
        currency: 'usd',
        customer: @business.stripe_customer_id,
        description: 'TODO: Add description' # TODO, add description
      )
    end
  end
end
