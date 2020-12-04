# frozen_string_literal: true

module V1
  module BusinessControllers
    class PinsController < ::ApplicationController # :nodoc:
      def index
        @pins = current_business.pins.ransack
        @pins = sort_and_paginate(@pins)

        meta_data = { total: @pins.count,
                      currentPage: @pins.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @pins.total_pages }

        render jsonapi: @pins, include: [firm: [:features, :schedules]], meta: meta_data
      end

      def create
        check_if_card_exists!

        if BusinessServices::ProfilePercentage.new(current_business).call < 100
          render jsonapi_errors: { detail: 'Complete 100% of your profile to be able to buy pins' }, status: 422
          return
        end

        pin_catalog = PinCatalog.find(params[:pin_catalog_id])

        service = PinServices::BuyPin.new(current_business, pin_catalog)
        service.call

        render jsonapi: service.pin, include: [firm: [:features, :schedules]], status: :created
      end

      def destroy
        @pin = current_business.pins.kept.find(params[:id])

        PinServices::StopPin.new(@pin).call

        head :no_content
      end

      def activate
        load_pin_to_activate
        activated_on = @pin.activated_on || Time.zone.now

        @pin.assign_attributes(
          lat: params[:latitude], lng: params[:longitude],
          activated_on: activated_on
        )

        if @pin.save
          render jsonapi: @pin, include: [firm: [:features, :schedules]]
        else
          render jsonapi_errors: @pin.errors
        end
      end

      private

      def check_if_card_exists!
        return if PaymentServices::CheckCardExists.new(
          current_business
        ).call

        raise PaymentException, 'No Credit Card on file'
      end

      def load_pin_to_activate
        @pin = current_business.pins.kept.can_activate.find(params[:id])
      end
    end
  end
end
