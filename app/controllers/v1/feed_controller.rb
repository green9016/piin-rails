# frozen_string_literal: true

module V1
  class PostsController < ApplicationController # :nodoc:
    def index
      @visisted_locations = current_user.visisted_locations.unseen
    end
  end
end
