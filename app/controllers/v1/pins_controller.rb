# frozen_string_literal: true

module V1
  class PinsController < ApplicationController # :nodoc:
    before_action :set_pin, only: :visit

    def visit
      service = PinServices::VisitPin.new(current_user, @pin,
                                          params[:lat], params[:lng])

      if service.call
        head :no_content, status: :ok
      else
        render jsonapi_errors: service.visited_location.errors,
               status: :unprocessable_entity
      end
    end

    private

    def set_pin
      @pin = Pin.find(params[:id])
    end
  end
end
