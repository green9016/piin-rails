# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Admin::PinsController, type: :controller do
  describe 'When authorization headers is present' do
    describe 'when authorized user is admin' do
      let(:user) { create(:user, role: 'admin') }
      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'POST-create pin' do
        let(:firm) { create(:firm) }
        let(:valid_params) { FactoryBot.attributes_for(:pin).merge(firm_id: firm.id) }
        let(:invalid_params) do
          {

          }
        end
        context 'when parameters are valid' do
          it 'successfully create a pin record' do
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

      describe 'PUT-update pin' do
        let(:pin) { create(:pin) }
        let(:params) do
          {
            'id' => pin.id,
            'colour' => 'red'
          }
        end
        let(:invalid_params) do
          {
            'id' => 'abc'
          }
        end

        context 'when parameters are valid' do
          it 'successfully update a pin record' do
            put :update, params: params
            expect(response.status).to eq 200
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['colour']).to eq 'red'
          end
        end

        context 'when parameters are invalid' do
          it 'return error' do
            put :update, params: invalid_params
            expect(response.status).to eq 404
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Pin with 'id'")
          end
        end
      end

      describe 'DELETE-delete pin' do
        let(:pin) { create(:pin) }
        let(:valid_params) { { 'id' => pin.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully delete the pin' do
            delete :destroy, params: valid_params
            expect(response.status).to eq 204
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            delete :destroy, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Pin with 'id'")
          end
        end
      end

      describe 'GET-show pin' do
        let(:pin) { create(:pin) }
        let(:valid_params) { { 'id' => pin.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully returns the pin' do
            get :show, params: valid_params
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['colour']).to eq(pin.colour)
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            get :show, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Pin with 'id'")
          end
        end
      end

      describe 'GET-list of pins' do
        let(:pin1) { create(:pin) }
        let(:pin2) { create(:pin) }

        it 'successfully returns the all pins' do
          get :index
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data'].size).to eq(Pin.count)
        end
      end
    end

    describe 'when authorized user is not admin' do
      let(:user1) { create(:user) }

      before do
        @request.headers['Authorization'] = "Bearer #{user1.token&.key}"
      end

      describe 'POST-create pin' do
        let(:firm) { create(:firm) }
        let(:valid_params) { FactoryBot.attributes_for(:pin).merge(firm_id: firm.id) }

        it 'return authorization error' do
          post :create, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'PUT-update pin' do
        let(:pin) { create(:pin) }
        let(:params) do
          {
            'id' => pin.id,
            'colour' => 'red'
          }
        end

        it 'return authorization error' do
          put :update, params: params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'DELETE-destroy pin' do
        let(:pin) { create(:pin) }
        let(:params) do
          {
            'id' => pin.id
          }
        end

        it 'return authorization error' do
          delete :destroy, params: params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:pin) { create(:pin) }
    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      put :update, params: { id: pin.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: pin.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: pin.id }
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
