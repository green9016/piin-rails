# frozen_string_literal: true

module V1
  class ReportsController < ApplicationController # :nodoc:
    before_action :set_report, only: %i[show update destroy]

    def index
      @reports = current_user.reports.ransack(description_cont: params[:q])
      @reports = sort_and_paginate(@reports)

      meta_data = { currentPage: @reports.current_page,
                    perPage: params[:perPage] || 10,
                    totalPages: @reports.total_pages }

      render jsonapi: @reports.uniq, include: %i[user post], meta: meta_data
    end

    def show
      render jsonapi: @report, include: %i[user post]
    end

    def create
      @report = current_user.reports.new(report_params)

      if @report.save
        render jsonapi: @report, include: %i[user post], status: :created
      else
        render jsonapi_errors: @report.errors, status: :unprocessable_entity
      end
    end

    def update
      if @report.update(report_params)
        render jsonapi: @report, include: %i[user post]
      else
        render jsonapi_errors: @report.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @report.destroy

      head :no_content
    end

    private

    def report_params
      params.permit(:post_id, :description,
                    :wrong_location, :false_offers,
                    :incorrect_open_hours, :wrong_phone_number,
                    :different_business_name, :other_reason)
    end

    def set_report
      @report = current_user.reports.find(params[:id])
    end
  end
end
