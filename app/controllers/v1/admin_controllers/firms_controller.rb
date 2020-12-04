# frozen_string_literal: true

module V1
  module AdminControllers
    class FirmsController < ::AdminController # :nodoc:
      before_action :set_firm, only: %i[show update destroy]

      # GET /firms.json
      def index
        @q = Firm.ransack
        set_search
        @firms = sort_and_paginate(@q)
        meta_data = { currentPage: @firms.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @firms.total_pages }
        render jsonapi: @firms.uniq,
               include: [:owner, :users, posts: [:reports]],
               meta: meta_data
      end

      # POST /firms.json
      def create
        @firm = Firm.new(firm_params)
        if @firm.save
          render jsonapi: @firm
        else
          render jsonapi_errors: @firm.errors
        end
      end

      # PATCH/PUT /firms/1.json
      def update
        if @firm.update(firm_params)
          render jsonapi: @firm
        else
          render jsonapi_errors: @firm.errors
        end
      end

      # GET /firms/1.json
      def show
        render jsonapi: @firm,
               include: [:users, :purchases, :pins, posts: [:reports]]
      end

      # DELETE /firms/1.json
      def destroy
        @firm.destroy
        head :no_content
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
                          name_cont: search, users_email_eq: search,
                          users_last_sign_in_at_eq: search, checked_eq: checked)
      end

      def firm_params
        params.permit(:photo, :name, :about, :business, :keywords, :status,
                      :lng, :city, :street, :zip, :lat, :state, :business_type,
                      :stripe_customer_token, :stripe_card_last_digits,
                      :stripe_card_brand, :balance, :checked, :owner_id,
                      :hashtags)
      end

      def set_firm
        @firm = Firm.find(params[:id])
      end

      # rubocop:disable Metrics/LineLength
      def ransack_condition
        :photo_or_name_or_about_business_or_keys_or_state_or_city_or_street_or_zip_or_stripe_customer_token_or_stripe_card_last_digits_or_stripe_card_brand_cont
      end
      # rubocop:enable Metrics/LineLength
    end
  end
end
