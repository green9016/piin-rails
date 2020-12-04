# frozen_string_literal: true

module V1
  module BusinessControllers
    class FeaturesController < ::ApplicationController # :nodoc:
      def index
        @features = Feature.all

        render jsonapi: @features, meta: {}
      end
    end
  end
end
