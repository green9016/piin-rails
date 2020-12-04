# frozen_string_literal: true

module V1
  module BusinessControllers
    class PinCatalogsController < ::ApplicationController # :nodoc:
      def index
        @pin_catalogs = PinCatalog.all.ransack
        @pin_catalogs = sort_and_paginate(@pin_catalogs)

        meta_data = { total: @pin_catalogs.count,
                      currentPage: @pin_catalogs.current_page,
                      perPage: params[:perPage] || 10,
                      totalPages: @pin_catalogs.total_pages }

        render jsonapi: @pin_catalogs, meta: meta_data
      end
    end
  end
end
