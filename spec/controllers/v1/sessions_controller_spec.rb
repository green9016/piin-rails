# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::SessionsController, type: :controller do
  describe 'Sign In' do
    let(:user_attributes) { attributes_for(:user) }
    let!(:user) { create(:user, user_attributes) }

    context 'when credentials are correct' do
      let(:params) do
        user_attributes.slice(:email, :password)
      end

      it 'responds with a 200 status' do
        post '/v1/auth/sign_in', params

        expect(response).to have_http_status(:ok)
      end

      it 'responds with user json' do
        post '/v1/auth/sign_in', params

        expect(json.keys).to match_array(%w[data jsonapi])
        expect(json['data']['id']).to eq(user.id.to_s)
        expect(json['data']['type']).to eq('users')
        expect(json['data']['attributes'].keys).to match_array(%w[email username first_name last_name])
        expect(json['data']['attributes']['email']).to eq(user_attributes[:email])
        expect(json['data']['attributes']['username']).to eq(user_attributes[:username])
        expect(json['data']['attributes']['first_name']).to eq(user_attributes[:first_name])
        expect(json['data']['attributes']['last_name']).to eq(user_attributes[:last_name])
        expect(json['data']['meta']).to be_empty
      end

      it 'responds with a token in the header'
      it 'responds with a token in the body'
    end

    context 'when credentials are incorrect' do
      let(:params) do
        {
          email: user_attributes[:email],
          password: 'wrongpass'
        }
      end

      it 'responds with a 400 status' do
        post '/v1/auth/sign_in', params

        expect(response).to have_http_status(:bad_request)
      end

      it 'responds with correct error message'
    end
  end

  describe 'DELETE sign_out' do
    let!(:user) { create(:user) }
    let(:token) { user.token&.key }

    context 'when request includes a valid token' do
      before do
        @request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'responds with a 200 status' do
        delete '/v1/auth/sign_out'

        expect(response).to have_http_status(:ok)
      end

      it 'invalidates the given token'
    end

    context 'when request does not include a valid token' do
      before do
        @request.headers['Authorization'] = 'Bearer invalidtoken'
      end

      it 'responds with a 400 status' do
        delete '/v1/auth/sign_out'

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
