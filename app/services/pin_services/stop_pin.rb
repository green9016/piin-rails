# frozen_string_literal: true

module PinServices
  class StopPin
    attr_reader :pin

    def initialize(pin)
      @pin = pin
    end

    def call
      if @pin.discarded?
        raise ActiveRecord::RecordInvalid, 'Pin already deleted'
      end

      @pin.transaction do
        @pin.discard

        if @pin.remaining_balance.positive?
          @pin.firm.pin_balances
              .create!(pin: @pin, amount_in_cents: @pin.remaining_balance)
        end
      end
    end
  end
end
