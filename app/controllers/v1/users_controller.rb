# frozen_string_literal: true

module V1
  class UsersController < ApplicationController # :nodoc:
    def subscription
      stripe_service = StripeService.new(params, current_user)
      result = stripe_service.create_subscription
      render_response(result)
    end

    def charge
      @pin = Pin.find_by(id: params[:pin_id])
      if @pin.present?
        stripe_service = StripeService.new(params, current_user, @pin)
        result = stripe_service.make_payment
        render_response(result)
      else
        render json: { message: 'Pin not found', status: 404 },
               status: :not_found
      end
    end

    def purchase_history
      purchases = current_user.purchases.filter_by(params)
      render jsonapi: purchases, include: %i[user pin]
    end

    def render_response(result)
      if result[:error].blank?
        render json: { message: nil, status: 200 }, status: :ok
      else
        render json: { message: result[:error], status: 422 },
               status: :unprocessable_entity
      end
    end

    def save_card_details
      stripe_service = StripeService.new(params, current_user)
      result = stripe_service.save_card
      if result[:error].blank?
        render json: { message: 'Card successfully saved', status: 200 },
               status: :ok
      else
        render json: { message: result[:error], status: 422 },
               status: :unprocessable_entity
      end
    end

    def pay
      pin = Pin.find(params[:pin_id])
      stripe_service = StripeService.new(params, current_user)
      result = stripe_service.make_payment
      if result[:error].blank?
        # TODO: save transaction history
        render json: { message: nil, status: 200 }, status: :ok
      else
        render json: { message: result[:error], status: 422 },
               status: :unprocessable_entity
      end
    end

    def payment_history
      csv = Purchase.generate_csv(user_purchases)
      send_payment_history_email(csv)

      render json: { message: nil, status: 200 }, status: :ok
    end

    private

    def user_purchases
      if params[:date].present?
        date = Date.parse(params[:date])

        current_user.purchases.where(
          created_at: (date.beginning_of_month)..(date.end_of_month)
        )
      else
        current_user.purchases.all
      end
    end

    def send_payment_history_email(csv)
      UserMailer.send_payment_history_email(current_user, csv).deliver
    end
  end
end
