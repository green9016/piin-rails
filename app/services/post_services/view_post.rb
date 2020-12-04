# frozen_string_literal: true

module PostServices
  class ViewPost
    def initialize(user, post)
      @user = user
      @post = post
    end

    def call
      @user.views.create!(post: @post)
    end
  end
end
