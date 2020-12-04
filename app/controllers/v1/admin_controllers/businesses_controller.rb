# frozen_string_literal: true

module V1
  module AdminControllers
    class BusinessesController < ::AdminController # :nodoc:
      before_action :set_business, only: %i[show update destroy]

      # GET /businesses.json
      def index
        search = params[:search]
        q = Business.all.ransack
        q.build_grouping(m: 'or', id_eq: search, email_cont: search)
        @businesses = sort_and_paginate(q)
        meta_data = { currentPage: @businesses.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @businesses.total_pages }
        render jsonapi: @businesses.uniq,
               include: %i[owned_firm payments support_tickets],
               meta: meta_data
      end

      # POST /businesses.json
      def create
        @business = Business.new(business_params)
        if @business.save
          render jsonapi: @business
        else
          render jsonapi_errors: @business.errors
        end
      end

      # PATCH/PUT /businesses/1.json
      def update
        if @business.update(business_params)
          render jsonapi: @business
        else
          render jsonapi_errors: @business.errors
        end
      end

      # GET /businesses/1.json
      def show
        render jsonapi: @business, include: %i[owned_firm]
      end

      # DELETE /businesses/1.json
      def destroy
        @business.destroy

        head :no_content
      end

      private

      def business_params
        params.permit(:email, :status, :photo, :first_name, :last_name,
                      :phone, :blocked)
      end

      def set_business
        @business = Business.find(params[:id])
      end
    end
  end
end
