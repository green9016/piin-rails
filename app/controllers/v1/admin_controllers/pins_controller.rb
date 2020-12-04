# frozen_string_literal: true

module V1
  module AdminControllers
    class PinsController < ::AdminController # :nodoc:
      before_action :set_pin, only: %i[show update destroy]

      # GET /pins.json
      def index
        search = params[:search]
        q = Pin.ransack
        q.build_grouping(m: 'or', id_eq: search, title_eq: search,
                         users_email_eq: search, firm_name_eq: search)
        @pins = sort_and_paginate(q)
        @pins.includes(:users, :firm)
        meta_data = { currentPage: @pins.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @pins.total_pages }
        render jsonapi: @pins.uniq, include: %i[firm users], meta: meta_data
      end

      # POST /pins.json
      def create
        @pin = Pin.new(pin_params)
        if @pin.save
          render jsonapi: @pin
        else
          render jsonapi_errors: @pin.errors
        end
      end

      # PATCH/PUT /pins/1.json
      def update
        if @pin.update(pin_params)
          render jsonapi: @pin
        else
          render jsonapi_errors: @pin.errors
        end
      end

      # GET /pins/1.json
      def show
        render jsonapi: @pin, include: %i[firm offers]
      end

      # DELETE /pins/1.json
      def destroy
        @pin.destroy
        head :no_content
      end

      private

      def pin_params
        params.permit(:firm_id, :icon, :colour, :range, :duration, :daily_price_in_cents,
                      :lat, :lng, :status, :business_id, :title, :checked)
      end

      def set_pin
        @pin = Pin.find(params[:id])
      end
    end
  end
end
