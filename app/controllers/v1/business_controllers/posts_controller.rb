# frozen_string_literal: true

module V1
  module BusinessControllers
    class PostsController < ::ApplicationController # :nodoc:
      before_action :set_post, only: %i[update show destroy]

      def index
        @posts = current_business.posts.ransack(
          photo_or_title_or_kinds_cont: params[:q]
        )
        @posts = sort_and_paginate(@posts)

        meta_data = { total: @posts.count,
                      currentPage: @posts.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @posts.total_pages }

        render jsonapi: @posts, include: [:offers, firm: [:features, :schedules]], meta: meta_data
      end

      def show
        render jsonapi: @post, include: [:offers, firm: [:features, :schedules]]
      end

      def create
        if BusinessServices::ProfilePercentage.new(current_business).call < 100
          render jsonapi_errors: { detail: 'Complete 100% of your profile to be able to post' }, status: 422
          return
        end

        @post = current_business.posts.new(post_params)
        @post.firm = current_business.owned_firm

        if @post.save
          render jsonapi: @post, include: [:offers, firm: [:features, :schedules]], status: :created
        else
          render jsonapi_errors: @post.errors, status: :unprocessable_entity
        end
      end

      def update
        if @post.update(post_params)
          render jsonapi: @post, include: [:offers, firm: [:features, :schedules]]
        else
          render jsonapi_errors: @post.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @post.active?
          @post.inactive!

          render jsonapi: @post, include: [:offers, firm: [:features, :schedules]]
        else
          @post.discard!

          head :no_content
        end
      end

      def preview
        if params[:id]
          @post = current_business.posts.find(params[:id])
          @post.assign_attributes(post_params)
        else
          @post = current_business.posts.new(post_params)
          @post.firm = current_business.owned_firm
        end

        render jsonapi: @post, include: [:offers, firm: [:features, :schedules]]
      end

      private

      def post_params
        params.permit(:photo, :title, :description, :color_code, :kinds,
                      offers_attributes: %i[id title week_days start_time
                                            end_time percent price])
      end

      def set_post
        @post = current_business.posts.find(params[:id])
      end
    end
  end
end
