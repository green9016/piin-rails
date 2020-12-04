# frozen_string_literal: true

module PinServices
  class VisitPin
    attr_reader :visited_location

    def initialize(user, pin, lat, lng)
      @user = user
      @pin = pin
      @lat = lat
      @lng = lng

      @visited_location = nil
    end

    def call
      return if user_visited_pin?

      @visited_location = @pin.visited_locations
                              .new(user: @user, lat: @lat, lng: @lng)

      @visited_location.save
    end

    private

    def user_visited_pin?
      @pin.visisted_locations.unseen.exists?(user: @user)
    end
  end
end
