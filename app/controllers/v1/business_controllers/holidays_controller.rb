# frozen_string_literal: true

module V1
  module BusinessControllers
    class HolidaysController < ::ApplicationController # :nodoc:
      def index
        @holidays = Holiday.kept.active.upcoming.sorted

        render jsonapi: @holidays, meta: {}
      end
    end
  end
end
