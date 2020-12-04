# frozen_string_literal: true

module V1
  module AdminControllers
    class HolidaysController < ::AdminController # :nodoc:
      before_action :set_holiday, only: %i[show update destroy]

      # GET /holidays.json
      def index
        search = params[:search]
        q = Holiday.ransack
        q.build_grouping(m: 'or', id_eq: search, status_eq: search,
                         title_cont: search)

        @holidays = sort_and_paginate(q)
        meta_data = { currentPage: @holidays.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @holidays.total_pages }
        render jsonapi: @holidays.uniq, meta: meta_data
      end

      # POST /holidays.json
      def create
        @holiday = Holiday.new(holiday_params)
        if @holiday.save
          render jsonapi: @holiday
        else
          render jsonapi_errors: @holiday.errors
        end
      end

      # PATCH/PUT /holidays/1.json
      def update
        if @holiday.update(holiday_params)
          render jsonapi: @holiday
        else
          render jsonapi_errors: @holiday.errors
        end
      end

      # GET /holidays/1.json
      def show
        render jsonapi: @holiday
      end

      # DELETE /holidays/1.json
      def destroy
        @holiday.destroy
        head :no_content
      end

      private

      def holiday_params
        params.permit(:title, :post_photo, :icon_photo,
                      :from_date, :until_date, :status)
      end

      def set_holiday
        @holiday = Holiday.find(params[:id])
      end
    end
  end
end
