# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MiscellaneousController, type: :controller do
  describe 'GET home' do
    it 'return success' do
      get 'home'
      expect(response).to have_http_status(:ok)
    end
  end
end
