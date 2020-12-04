# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Admin::HolidaysController, type: :controller do
  describe 'When authorization headers is present' do
    let(:user) { create(:user) }
    before do
      @request.headers['Authorization'] = "Bearer #{user.get_token&.key}"
    end

    describe 'POST-create holiday' do
      let(:valid_params) { FactoryBot.attributes_for(:holiday) }
      let(:invalid_params) do
        {

        }
      end
      context 'when parameters are valid' do
        it 'successfully create a holiday record' do
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

    describe 'PUT-update holiday' do
      let(:holiday) { create(:holiday) }
      let(:params) do
        {
          'id' => holiday.id,
          'title' => 'newholiday'
        }
      end

      context 'when parameters are valid' do
        it 'successfully update a holiday record' do
          put :update, params: params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['title']).to eq 'newholiday'
        end
      end
    end

    describe 'DELETE-delete holiday' do
      let(:holiday) { create(:holiday) }
      let(:valid_params) { { 'id' => holiday.id } }
      let(:invalid_params) { { 'id' => 'abc' } }

      context 'when parameters are valid' do
        it 'successfully delete the holiday' do
          delete :destroy, params: valid_params
          expect(response.status).to eq 204
        end
      end

      context 'when parameters are not valid' do
        it 'returns with error' do
          delete :destroy, params: invalid_params
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Holiday with 'id'")
        end
      end
    end

    describe 'GET-show holiday' do
      let(:holiday) { create(:holiday) }
      let(:valid_params) { { 'id' => holiday.id } }
      let(:invalid_params) { { 'id' => 'abc' } }

      context 'when parameters are valid' do
        it 'successfully returns the holiday' do
          get :show, params: valid_params
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['title']).to eq(holiday.title)
        end
      end

      context 'when parameters are not valid' do
        it 'returns with error' do
          get :show, params: invalid_params
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Holiday with 'id'")
        end
      end
    end

    describe 'GET-list of holiday' do
      let(:holiday1) { create(:holiday) }
      let(:holiday2) { create(:holiday) }

      it 'successfully returns the all holidays' do
        get :index
        expect(response.status).to eq 200
        expect(JSON.parse(response.body))
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:holiday) { create(:holiday) }
    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      put :update, params: { id: holiday.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: holiday.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: holiday.id }
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
