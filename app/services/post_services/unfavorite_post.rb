# frozen_string_literal: true

module PostServices
  class UnfavoritePost
    def initialize(user, post)
      @user = user
      @post = post
    end

    def call
      @post.like_dislikes.where(user: @user).delete_all
    end
  end
end
