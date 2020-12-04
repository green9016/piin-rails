# frozen_string_literal: true
require 'csv'

module PaymentServices
  class GenerateCsv
    def initialize(payments)
      @payments = payments
    end

    def call
      attributes = %w[id business_id firm_id pin_id amount_in_cents stripe_charge_id created_at]

      CSV.generate(headers: true) do |csv|
        csv << attributes

        @payments.each do |payment|
          csv << attributes.map { |attr| payment.send(attr) }
        end
      end
    end
  end
end
