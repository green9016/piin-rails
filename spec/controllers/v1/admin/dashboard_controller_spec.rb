# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Admin::DashboardController, type: :controller do
  describe 'Get-stats' do
    context 'when user is admin' do
      let(:role) { create(:role, name: 'admin') }
      let(:user) { create(:user, role_id: role.id) }
      it 'successfully get the stats for the dashboard' do
        request.headers['Authorization'] = "Bearer #{user.token&.key}"
        get :stats
        expect(response.status).to eq 200
        expect(response.content_type).to eq 'application/json'
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      it 'successfully get the stats for the dashboard' do
        request.headers['Authorization'] = "Bearer #{user.token&.key}"
        get :stats
        expect(response.status).to eq 401
        expect(response.content_type).to eq 'application/json'
        expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
      end
    end

    context 'When authorization headers is not present' do
      it 'returns token error when stats is called' do
        get :stats
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)['message']).to eq('Token not found!')
      end
    end
  end
end
