# frozen_string_literal: true

module V1Helper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end
