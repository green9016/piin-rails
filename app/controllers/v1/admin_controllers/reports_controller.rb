# frozen_string_literal: true

module V1
  module AdminControllers
    class ReportsController < ::AdminController
      before_action :set_report, only: %i[show update]

      def index
        @q = Report.all.ransack
        set_search
        @reports = sort_and_paginate(@q)
        @reports.includes(:user, :firm)
        meta_data = { currentPage: @reports.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @reports.total_pages }
        render jsonapi: @reports.uniq,
               include: [:user, post: [:firm]],
               meta: meta_data
      end

      def show
        render jsonapi: @report, include: [:user, post: [:firm]]
      end

      def update
        if @report.update(report_params)
          render jsonapi: @report
        else
          render jsonapi_errors: @report.errors
        end
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
        @q.build_grouping(m: 'or', id_eq: search,
                          user_username_eq: search, user_email_eq: search,
                          checked_eq: checked, firm_name_cont: search)
      end

      def report_params
        params.permit(:checked)
      end

      def set_report
        @report = Report.find_by!(id: params[:id])
      end
    end
  end
end
