# frozen_string_literal: true

module PostServices
  class LikePost
    def initialize(user, post)
      @user = user
      @post = post
    end

    def call
      @post.like_dislikes.find_or_create_by!(user: @user).tap do |like_dislike|
        like_dislike.update_attribute(:is_like, true)
      end
    end
  end
end
