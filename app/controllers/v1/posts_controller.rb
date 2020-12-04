# frozen_string_literal: true

module V1
  class PostsController < ApplicationController # :nodoc:
    before_action :set_post, only: %i[show like dislike unfavorite]

    def index
      @posts = PostServices::PostsForUser.new(current_user).call

      @posts = @posts.ransack(photo_or_title_or_kinds_cont: params[:q])
      @posts = sort_and_paginate(@posts)

      meta_data = { currentPage: @posts.current_page,
                    perPage: params[:perPage] || 10,
                    totalPages: @posts.total_pages }

      render jsonapi: @posts.uniq, include:
        [:offers, firm: %i[features schedules]], meta: meta_data
    end

    def show
      PostServices::ViewPost.new(current_user, @post).call

      render jsonapi: @post, include: [:offers, firm: %i[features schedules]]
    end

    def like
      PostServices::LikePost.new(current_user, @post).call

      render jsonapi: @post, include: [:offers, firm: %i[features schedules]]
    rescue StandardError
      # TODO, rollbar
      render jsonapi_errors: { detail: 'Error when liking this post' },
             status: :unprocessable_entity
    end

    def dislike
      PostServices::DislikePost.new(current_user, @post).call

      render jsonapi: @post, include: [:offers, firm: %i[features schedules]]
    rescue StandardError
      # TODO, rollbar
      render jsonapi_errors: { detail: 'Error when disliking this post' },
             status: :unprocessable_entity
    end

    def unfavorite
      PostServices::UnfavoritePost.new(current_user, @post).call

      render jsonapi: @post, include: [:offers, firm: %i[features schedules]]
    rescue StandardError
      # TODO, rollbar
      render jsonapi_errors: { detail: 'Error when removing this post from favorites' },
             status: :unprocessable_entity
    end

    def favorites
      @posts = current_user.liked_posts

      @posts = @posts.ransack(photo_or_title_or_kinds_cont: params[:q])
      @posts = sort_and_paginate(@posts)

      meta_data = { currentPage: @posts.current_page,
                    perPage: params[:perPage] || 10,
                    totalPages: @posts.total_pages }

      render jsonapi: @posts.uniq, include: [:offers, firm: %i[features schedules]], meta: meta_data
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end
  end
end
