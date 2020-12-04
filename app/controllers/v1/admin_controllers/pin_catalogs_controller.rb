# frozen_string_literal: true

module V1
  module AdminControllers
    class PinCatalogsController < ::AdminController # :nodoc:
      before_action :set_pin_catalog, only: %i[show update destroy]

      def index
        @q = PinCatalog.ransack(id_eq: params[:search])
        @pin_catalogs = sort_and_paginate(@q)
        meta_data = {
          currentPage: @pin_catalogs.current_page,
          perPage: params[:perPage] || 10,
          totalPages: @pin_catalogs.total_pages
        }
        render jsonapi: @pin_catalogs.uniq,
               meta: meta_data, include: [:payments, pins: [:firm, :business]]
      end

      # POST /pin_catalogs.json
      def create
        @pin_catalog = PinCatalog.new(pin_catalog_params)
        if @pin_catalog.save
          render jsonapi: @pin_catalog
        else
          render jsonapi_errors: @pin_catalog.errors
        end
      end

      # PATCH/PUT /pin_catalogs/1.json
      def update
        if @pin_catalog.update(pin_catalog_params)
          render jsonapi: @pin_catalog
        else
          render jsonapi_errors: @pin_catalog.errors
        end
      end

      # GET /pin_catalogs/1.json
      def show
        render jsonapi: @pin_catalog
      end

      # DELETE /pin_catalogs/1.json
      def destroy
        @pin_catalog.destroy
        head :no_content
      end

      private

      def pin_catalog_params
        params.permit(:title, :description, :banner,
                      :icon, :color, :miles, :range,
                      :duration_in_days, :daily_price_in_cents,
                      :discarded_at, :status)
      end

      def set_pin_catalog
        @pin_catalog = PinCatalog.find(params[:id])
      end
    end
  end
end
