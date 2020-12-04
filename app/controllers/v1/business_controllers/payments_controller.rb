# frozen_string_literal: true

module V1
  module BusinessControllers
    class PaymentsController < ::ApplicationController # :nodoc:
      def index
        @payments = current_business.payments
        @payments = sort_and_paginate(@payments)

        meta_data = { total: @payments.count,
                      currentPage: @payments.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @payments.total_pages }
        render jsonapi: @payments, meta: meta_data
      end

      def send_payments
        if current_business.payments.any?
          csv = PaymentServices::GenerateCsv.new(current_business.payments).call
          BusinessMailer.send_business_payment_history(current_business, csv).deliver_now if csv
        end

        head :no_content
      end
    end
  end
end
