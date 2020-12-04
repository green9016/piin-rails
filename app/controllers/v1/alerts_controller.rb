# frozen_string_literal: true

module V1
  class AlertsController < ApplicationController # :nodoc:
    before_action :set_notification, except: %i[index]
    before_action :set_alert, only: %i[show update destroy]

    def index
      alerts = sort_and_paginate(find_alerts.ransack(params[:q]))
      meta_data = { currentPage: alerts.current_page,
                    perPage: params[:perPage] || 10,
                    totalPages: alerts.total_pages }
      render jsonapi: alerts.uniq, include: %i[notification user],
             meta: meta_data
    end

    def create
      @alert = @notification.alerts.new(user: current_user,
                                        active: params_active)
      if @alert.save
        render jsonapi: @alert, status: :created
      else
        render jsonapi_errors: @alert.errors, status: :unprocessable_entity
      end
    end

    def update
      if @alert.update(active: params.require(:active))
        render jsonapi: @alert
      else
        render jsonapi_errors: @alert.errors, status: :unprocessable_entity
      end
    end

    def show
      render jsonapi: @alert, include: %i[notification user]
    end

    def destroy
      @alert.destroy

      head :no_content
    end

    private

    def set_notification
      @notification = Notification.find(params[:notification_id])
    end

    def set_alert
      @alert = current_user.alerts.find(params[:id])
    end

    def params_active
      params[:active]
    end

    def find_alerts
      alerts = current_user.alerts

      return alerts.where(active: params_active) if params_active.present?

      alerts
    end
  end
end
