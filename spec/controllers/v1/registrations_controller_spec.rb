# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RegistrationsController, type: :controller do
  fixtures :all

  describe 'POST sign_up' do
    let(:role) { create(:role) }
    it 'return created' do
      params = {
        user: {
          email: 'testuser@email.com',
          username: 'testuser',
          first_name: 'Test',
          last_name: 'User',
          birthday: Time.now - 18.years,
          password: '123456789',
          new_deals: true,
          timer: false,
          role_id: role.id
        },
        format: 'json'
      }
      post :sign_up, params: params
      expect(response).to have_http_status(:created)
    end

    it 'return unprocessable_entity' do
      params = {
        user: {
          username: 'testuser'
        },
        format: 'json'
      }
      post :sign_up, params: params
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON(response.body)
      expect(json_response['message']).not_to eq(nil)
    end
  end

  describe 'PATCH update' do
    let(:user) { create(:user) }
    before do
      @request.headers['Authorization'] = "Bearer #{user.token&.key}"
    end

    it 'return ok' do
      params = {
        id: user.id, # Not really necessary, token is the determinant!
        user: {
          birthday: Time.now - 28.years
        }
      }
      patch :update, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'return unprocessable_entity' do
      params = {
        id: 1, # Not really necessary, token is the determinant!
        user: {
          email: nil
        }
      }
      patch :update, params: params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
