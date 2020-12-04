# frozen_string_literal: true

module V1
  module AdminControllers
    class UsersController < ::AdminController # :nodoc:
      before_action :set_user, only: %i[show update destroy]

      # GET /users.json
      def index
        search = params[:search]
        q = User.ransack
        q.build_grouping(m: 'or', id_eq: search, username_cont: search,
                         email_cont: search)
        @users = sort_and_paginate(q)
        meta_data = { currentPage: @users.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @users.total_pages }
        render jsonapi: @users.uniq, include: [:reports], meta: meta_data
      end

      # POST /users.json
      def create
        @user = User.new(user_params)
        if @user.save
          render jsonapi: @user
        else
          render jsonapi_errors: @user.errors
        end
      end

      # PATCH/PUT /users/1.json
      def update
        if @user.update(user_params)
          render jsonapi: @user
        else
          render jsonapi_errors: @user.errors
        end
      end

      # GET /users/1.json
      def show
        render jsonapi: @user, include: %i[reports]
      end

      # DELETE /users/1.json
      def destroy
        @user.destroy
        head :no_content
      end

      private

      def user_params
        params.permit(:email, :username, :status, :photo, :first_name,
                      :last_name, :birthday, :lat, :lng, :password,
                      :password_confirmation, :role, :phone, :blocked)
      end

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
