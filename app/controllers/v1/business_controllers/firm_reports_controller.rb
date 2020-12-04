# frozen_string_literal: true

module V1
  module BusinessControllers
    class FirmReportsController < ::ApplicationController
      def index
        firm = current_business.owned_firm
        current_month = Time.zone.today.beginning_of_month

        @firm_reports = []
        date = firm.created_at.beginning_of_month
        while date < current_month
          firm_report = firm.firm_reports.where(month: date.month, year: date.year).first
          if firm_report.nil?
            firm_report = FirmReport.build_for_month(firm, date.month, date.year).tap do |fr|
              fr.save
            end
          end

          @firm_reports << firm_report

          date = date.next_month
        end 

        render jsonapi: @firm_reports, include: %i[firm]
      end

      def current
        @firm_report = FirmReport.build_current(current_business.owned_firm)

        render jsonapi: @firm_report, include: %i[firm]
      end
    end
  end
end
