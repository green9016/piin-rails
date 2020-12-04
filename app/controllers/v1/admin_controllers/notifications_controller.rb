# frozen_string_literal: true

module V1
  module AdminControllers
    class NotificationsController < ::AdminController # :nodoc:
      before_action :set_notification, only: %i[show update destroy]

      # GET /notifications.json
      def index
        q = Notification.ransack(name_or_description_cont: params[:q])
        @notifications = sort_and_paginate(q)
        meta_data = { currentPage: @notifications.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @notifications.total_pages }
        render jsonapi: @notifications.uniq, meta: meta_data
      end

      # POST /notifications.json
      def create
        @notification = Notification.new(notification_params)
        if @notification.save
          render jsonapi: @notification
        else
          render jsonapi_errors: @notification.errors
        end
      end

      # PATCH/PUT /notifications/1.json
      def update
        if @notification.update(notification_params)
          render jsonapi: @notification
        else
          render jsonapi_errors: @notification.errors
        end
      end

      # GET /notifications/1.json
      def show
        render jsonapi: @notification
      end

      # DELETE /notifications/1.json
      def destroy
        @notification.destroy
        head :no_content
      end

      def unchecked_notification
        values = { unchecked_business: Firm.unchecked.count,
                   unchecked_post: Post.unchecked.count,
                   unchecked_report: Report.unchecked.count,
                   unchecked_support: SupportTicket.unchecked.count }
        render json: { type: 'notification', id: '', attributes: values }
      end

      private

      def notification_params
        params.permit(:name, :description, :business)
      end

      def set_notification
        @notification = Notification.find(params[:id])
      end
    end
  end
end
