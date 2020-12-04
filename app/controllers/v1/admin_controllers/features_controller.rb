# frozen_string_literal: true

module V1
  module AdminControllers
    class FeaturesController < ::AdminController # :nodoc:
      before_action :set_feature, only: %i[show update destroy]

      # GET /features.json
      def index
        q = Feature.ransack(icon_or_name_or_description_cont: params[:q])
        @features = sort_and_paginate(q)
        meta_data = { currentPage: @features.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @features.total_pages }
        render jsonapi: @features.uniq, include: %i[firms], meta: meta_data
      end

      # POST /features.json
      def create
        @feature = Feature.new(feature_params)
        if @feature.save
          render jsonapi: @feature
        else
          render jsonapi_errors: @feature.errors
        end
      end

      # PATCH/PUT /features/1.json
      def update
        if @feature.update(feature_params)
          render jsonapi: @feature
        else
          render jsonapi_errors: @feature.errors
        end
      end

      # GET /features/1.json
      def show
        render jsonapi: @feature
      end

      # DELETE /features/1.json
      def destroy
        @feature.destroy
        head :no_content
      end

      private

      def feature_params
        params.permit(:icon, :name, :description)
      end

      def set_feature
        @feature = Feature.find(params[:id])
      end
    end
  end
end
