# frozen_string_literal: true

module PinServices
  class ListVisitedPins
    VISIT_EXPIRE_IN_DAYS = 5

    def initialize(user)
      @user = user
    end

    def call
      @user.visited_pins
           .where('visited_locations.created_at >= ?',
                  VISIT_EXPIRE_IN_DAYS.days.ago)
    end
  end
end
