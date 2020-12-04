# frozen_string_literal: true

module V1
  module AdminControllers
    class PostsController < ::AdminController # :nodoc:
      before_action :set_post, only: %i[show update destroy]

      # GET /posts.json
      def index
        @q = Post.ransack
        set_search
        @posts = sort_and_paginate(@q)
        meta_data = { currentPage: @posts.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @posts.total_pages }
        render jsonapi: @posts.uniq,
               include: [:business, :offers, :users, :like_dislikes, firm: [:owner]],
               meta: meta_data
      end

      # POST /posts.json
      def create
        @post = Post.new(post_params)
        if @post.save
          render jsonapi: @post
        else
          render jsonapi_errors: @post.errors, status: 422
        end
      end

      # PATCH/PUT /posts/1.json
      def update
        if @post.update(post_params)
          render jsonapi: @post.reload
        else
          render jsonapi_errors: @post.errors, status: 422
        end
      end

      # GET /posts/1.json
      def show
        render jsonapi: @post, include: %i[users firm offers]
      end

      # DELETE /posts/1.json
      def destroy
        @post.destroy

        head :no_content
      end

      # GET /posts/search
      def search
        posts = Post.ransack(title_cont: params[:search]).result
        offers = Offer.ransack(title_cont: params[:search]).result
        result = posts + offers
        render json: { total: result.length, data: result }
      end

      private

      def set_search
        search = params[:search]
        checked = nil
        if search == 'checked'
          checked = true
        elsif search == 'unchecked'
          checked = false
        end
        @q.build_grouping(m: 'or', id_eq: search, status_eq: search,
                          title_cont: search, users_email_eq: search,
                          checked_eq: checked, firm_name_eq: search)
      end

      def post_params
        params.permit(:firm_id, :photo, :title, :kinds,
                      :checked, :status, :business_id,
                      :description, :color_code,
                      offers_attributes: %i[id title week_days start_time
                                            end_time percent price])
      end

      def set_post
        @post = Post.find(params[:id])
      end

      def ransack_condition
        :photo_or_title_or_kinds_or_description_or_color_code_cont
      end
    end
  end
end
