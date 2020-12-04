# frozen_string_literal: true

module V1
  module AdminControllers
    class PaymentsController < ::AdminController # :nodoc:
      before_action :set_payment, only: %i[show update destroy]

      def index
        q = Payment.ransack(id_eq: params[:search])
        @payments = sort_and_paginate(q)
        meta_data = { currentPage: @payments.current_page,
                      perPage: params[:perPage].to_i || 10,
                      totalPages: @payments.total_pages }
        render jsonapi: @payments,
               include: %i[business pin firm],
               meta: meta_data
      end

      # POST /payments.json
      def create
        @payment = Payment.new(payment_params)
        if @payment.save
          render jsonapi: @payment
        else
          render jsonapi_errors: @payment.errors
        end
      end

      # PATCH/PUT /payments/1.json
      def update
        if @payment.update(payment_params)
          render jsonapi: @payment
        else
          render jsonapi_errors: @payment.errors
        end
      end

      # GET /payments/1.json
      def show
        render jsonapi: @payment
      end

      # DELETE /payments/1.json
      def destroy
        @payment.destroy
        head :no_content
      end

      private

      def payment_params
        params.permit(:business_id, :firm_id, :pin_id,
                      :amount_in_cents, :stripe_charge_id)
      end
    end
  end
end
