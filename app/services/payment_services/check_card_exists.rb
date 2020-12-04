# frozen_string_literal: true

module PaymentServices
  class CheckCardExists
    def initialize(business)
      @business = business
    end

    def call
      return false unless @business.stripe_customer_id.present?

      customer = Stripe::Customer.retrieve(@business.stripe_customer_id)
      customer['default_source'].present?
    rescue Stripe::InvalidRequestError
      false
    end
  end
end
