# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Admin::NotificationsController, type: :controller do
  describe 'When authorization headers is present' do
    describe 'when authorized user is admin' do
      let(:role) { create(:role, name: 'admin') }
      let(:user) { create(:user, role_id: role.id) }
      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'POST-create notification' do
        let(:valid_params) { FactoryBot.attributes_for(:notification) }
        let(:invalid_params) do
          {
            'name' => '',
            'business' => '',
            'description' => ''
          }
        end
        context 'when parameters are valid' do
          it 'successfully create a notification record' do
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

      describe 'PUT-update notification' do
        let(:notification) { create(:notification) }
        let(:params) do
          {
            'id' => notification.id,
            'description' => 'newdescription'
          }
        end
        let(:invalid_params) do
          {
            'id' => 'abc',
            'description' => 'newdescription',
            'business' => false
          }
        end

        context 'when parameters are valid' do
          it 'successfully update a notification record' do
            put :update, params: params
            expect(response.status).to eq 200
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['description']).to eq 'newdescription'
          end
        end

        context 'when parameters are not  valid' do
          it 'successfully update a notification record' do
            put :update, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Notification with 'id'")
          end
        end
      end

      describe 'DELETE-delete notification' do
        let(:notification) { create(:notification) }
        let(:valid_params) { { 'id' => notification.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully delete the notification' do
            delete :destroy, params: valid_params
            expect(response.status).to eq 204
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            delete :destroy, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Notification with 'id'")
          end
        end
      end

      describe 'GET-show notification' do
        let(:notification) { create(:notification) }
        let(:valid_params) { { 'id' => notification.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully returns the notification' do
            get :show, params: valid_params
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['name']).to eq(notification.name)
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            get :show, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Notification with 'id'")
          end
        end
      end

      describe 'GET-list of notifications' do
        let!(:notification1) { create(:notification) }
        let!(:notification2) { create(:notification) }

        it 'successfully returns the all notifications' do
          get :index
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data'].size).to eq(Notification.count)
        end
      end
    end

    describe 'when authorized user is not admin' do
      let(:user) { create(:user) }
      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'POST-create notification' do
        let(:valid_params) { FactoryBot.attributes_for(:notification) }

        it 'return unauthorized error' do
          post :create, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'PUT-update notification' do
        let(:notification) { create(:notification) }
        let(:valid_params) do
          {
            'id' => notification.id,
            'name' => 'descriptionname'
          }
        end

        it 'return unauthorized error' do
          put :update, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'DELETE-destroy notification' do
        let(:notification) { create(:notification) }
        let(:valid_params) do
          {
            'id' => notification.id
          }
        end

        it 'return unauthorized error' do
          delete :destroy, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
        end
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:notification) { create(:notification) }
    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      put :update, params: { id: notification.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: notification.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: notification.id }
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
