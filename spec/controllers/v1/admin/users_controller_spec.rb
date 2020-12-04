# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Admin::UsersController, type: :controller do
  describe 'When authorization headers is present' do
    describe 'When logged user is admin' do
      let(:role) { create(:role, name: 'admin') }
      let(:user) { create(:user, role_id: role.id) }
      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'POST-create user' do
        let(:role_new) { create(:role) }
        let(:valid_params) { FactoryBot.attributes_for(:user, role_id: role_new.id) }
        let(:invalid_params) do
          {
            'email' => '',
            'password' => '',
            'username' => ''
          }
        end

        context 'when parameters are valid' do
          it 'successfully create a user record' do
            post :create, params: valid_params
            expect(response.status).to eq 201
            expect(response.content_type).to eq 'application/json'
          end
        end

        context 'when parameters are invalid' do
          it 'return with error' do
            post :create, params: invalid_params
            expect(response.status).to eq 422
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['message']).to include('Validation failed:')
          end
        end
      end

      describe 'PUT-update user' do
        let(:user1) { create(:user) }
        let(:params) do
          {
            'id' => user1.id,
            'username' => 'newtestuser'
          }
        end

        context 'when parameters are valid' do
          it 'successfully update a user record' do
            put :update, params: params
            expect(response.status).to eq 200
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['username']).to eq 'newtestuser'
          end
        end
      end

      describe 'DELETE-delete user' do
        let(:user1) { create(:user) }
        let(:valid_params) { { 'id' => user1.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully delete the user' do
            delete :destroy, params: valid_params
            expect(response.status).to eq 204
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            delete :destroy, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find User with 'id'")
          end
        end
      end

      describe 'GET-show user' do
        let(:user1) { create(:user) }
        let(:valid_params) { { 'id' => user1.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully display the user' do
            get :show, params: valid_params
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['users']['username']).to eq(user1.username)
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            get :show, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find User with 'id'")
          end
        end
      end

      describe 'GET-list of users' do
        let(:user1) { create(:user) }
        let(:user2) { create(:user) }

        it 'successfully returns the all users' do
          get :index
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data'].size).to eq(User.count)
        end
      end
    end

    describe 'When logged user is not admin' do
      let(:role) { create(:role) }
      let(:user) { create(:user, role_id: role.id) }
      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'POST-create user' do
        let(:valid_params) { FactoryBot.attributes_for(:user, role_id: role.id) }

        it 'return error' do
          post :create, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'PUT-update user' do
        let(:user1) { create(:user) }
        let(:params) do
          {
            'id' => user1.id,
            'username' => 'newtestuser'
          }
        end

        it 'return error' do
          put :update, params: params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'DELETE-delete-destroy user' do
        let(:user1) { create(:user) }
        let(:valid_params) do
          {
            'id' => user1.id
          }
        end

        it 'return error' do
          delete :destroy, params: valid_params
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'GET-show' do
        let(:user1) { create(:user) }
        let(:valid_params) do
          {
            'id' => user1.id
          }
        end

        it 'return error' do
          get :show, params: valid_params
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:user1) { create(:user) }
    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      put :update, params: { id: user1.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: user1.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: user1.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when index is called' do
      get :index
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end
  end
end
