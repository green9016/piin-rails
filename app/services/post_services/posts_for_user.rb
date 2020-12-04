# frozen_string_literal: true

module PostServices
  class PostsForUser
    def initialize(user)
      @user = user
    end

    def call
      pins_ids = PinServices::ListVisitedPins.new(@user).call.pluck(:id)

      Post.kept.distinct.joins(:pins).where(pins: { id: pins_ids })
    end
  end
end
