# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Admin::FirmsController, type: :controller do
  describe 'When authorization headers is present' do
    describe 'when authorized user is admin' do
      let(:role) { create(:role, name: 'admin') }
      let(:user) { create(:user, role_id: role.id) }
      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'POST-create firm' do
        let(:valid_params) { FactoryBot.attributes_for(:firm) }
        let(:invalid_params) do
          {
            'photo' => '',
            'name' => '',
            'about' => '',
            'business' => '',
            'keywords' => '',
            'balance' => '',
            'state' => '',
            'city' => '',
            'street' => '',
            'zip' => '',
            'lat' => '',
            'lng' => '',
            'status' => ''
          }
        end

        context 'when parameters are valid' do
          it 'successfully create a firm record' do
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

      describe 'PUT-update firm' do
        let(:firm) { create(:firm, owner: user) }
        let(:params) do
          {
            'id' => firm.id,
            'name' => 'newname'
          }
        end
        let(:invalid_params) do
          {
            'id' => 'abc',
            'about' => 'newdescription'
          }
        end

        context 'when parameters are valid' do
          it 'successfully update a firm record' do
            put :update, params: params
            expect(response.status).to eq 200
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['name']).to eq 'newname'
          end
        end

        context 'when parameters are not  valid' do
          it 'successfully update a firm record' do
            put :update, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Firm with 'id'")
          end
        end
      end

      describe 'DELETE-delete firm' do
        let(:firm) { create(:firm, owner: user) }
        let(:valid_params) { { 'id' => firm.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully delete the firm' do
            delete :destroy, params: valid_params
            expect(response.status).to eq 204
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            delete :destroy, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Firm with 'id'")
          end
        end
      end

      describe 'GET-show firm' do
        let(:firm) { create(:firm, owner: user) }
        let(:valid_params) { { 'id' => firm.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully display the firm' do
            get :show, params: valid_params
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['name']).to eq(firm.name)
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            get :show, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Firm with 'id'")
          end
        end
      end

      describe 'GET-list of firm' do
        let!(:firm1) { create(:firm, owner: user) }
        let!(:firm2) { create(:firm, owner: user) }

        it 'successfully returns the all firms' do
          get :index
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data'].size).to eq(Firm.count)
        end
      end
    end

    describe 'when authorized user is not admin' do
      let(:role) { create(:role) }
      let(:user) { create(:user) }
      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'Post-create firm' do
        let(:valid_params) { FactoryBot.attributes_for(:firm, owner: user) }

        it 'return unauthorized error ' do
          post :create, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'PUT-update firm' do
        let(:firm) { create(:firm, owner: user) }
        let(:params) do
          {
            'id' => firm.id,
            'name' => 'newname'
          }
        end

        it 'return unauthorized error' do
          put :update, params: params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'DELETE-delete firm' do
        let(:firm) { create(:firm, owner: user) }
        let(:valid_params) { { 'id' => firm.id } }

        it 'return unauthorized error' do
          delete :destroy, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:firm) { create(:firm) }
    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      put :update, params: { id: firm.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: firm.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: firm.id }
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
