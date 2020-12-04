# frozen_string_literal: true

module V1
  module AdminControllers
    class OffersController < ::AdminController # :nodoc:
      before_action :set_offer, only: %i[show update destroy]

      def index
        q = Offer.ransack(id_eq: params[:search])
        @offers = sort_and_paginate(q)
        meta_data = { currentPage: @offers.current_page,
                      perPage: params[:perPage].to_i || 10,
                      totalPages: @offers.total_pages }
        render jsonapi: @offers, meta: meta_data
      end

      # POST /offers.json
      def create
        @offer = Offer.new(offer_params)
        if @offer.save
          render jsonapi: @offer
        else
          render jsonapi_errors: @offer.errors
        end
      end

      # PATCH/PUT /offers/1.json
      def update
        if @offer.update(offer_params)
          render jsonapi: @offer
        else
          render jsonapi_errors: @offer.errors
        end
      end

      # GET /offers/1.json
      def show
        render jsonapi: @offer
      end

      # DELETE /offers/1.json
      def destroy
        @offer.destroy
        head :no_content
      end

      private

      def offer_params
        params.permit(:post_id, :title, :price,
                      :percent, :status, :start_time, :end_time, :week_days)
      end
    end
  end
end
