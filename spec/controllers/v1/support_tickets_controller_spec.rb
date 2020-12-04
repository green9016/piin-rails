# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::SupportTicketsController, type: :controller do
  describe 'When authorization headers is present' do
    let(:user) { create(:user) }
    before do
      @request.headers['Authorization'] = "Bearer #{user.token&.key}"
    end

    describe 'POST-create support_ticket' do
      let(:valid_params) { FactoryBot.attributes_for(:support_ticket).merge(user_id: user.id) }
      let(:invalid_params) do
        {

        }
      end
      context 'when parameters are valid' do
        it 'successfully create a support ticket record' do
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

    describe 'PUT-update support_ticket' do
      let(:support_ticket) { create(:support_ticket) }
      let(:params) do
        {
          'id' => support_ticket.id,
          'status' => 'pending'
        }
      end

      context 'when parameters are valid' do
        it 'successfully update a support_ticket record' do
          put :update, params: params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['status']).to eq 'pending'
        end
      end
    end

    describe 'DELETE-delete support_ticket' do
      let(:support_ticket) { create(:support_ticket) }
      let(:valid_params) { { 'id' => support_ticket.id } }
      let(:invalid_params) { { 'id' => 'abc' } }

      context 'when parameters are valid' do
        it 'successfully delete the support_ticket' do
          delete :destroy, params: valid_params
          expect(response.status).to eq 204
        end
      end

      context 'when parameters are not valid' do
        it 'returns with error' do
          delete :destroy, params: invalid_params
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['message']).to include("Couldn't find SupportTicket with 'id'")
        end
      end
    end

    describe 'GET-show support ticket' do
      let(:support_ticket) { create(:support_ticket) }
      let(:valid_params) { { 'id' => support_ticket.id } }
      let(:invalid_params) { { 'id' => 'abc' } }

      context 'when parameters are valid' do
        it 'successfully returns support ticket' do
          get :show, params: valid_params
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['status']).to eq(support_ticket.status)
        end
      end

      context 'when parameters are not valid' do
        it 'returns with error' do
          get :show, params: invalid_params
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['message']).to include("Couldn't find SupportTicket with 'id'")
        end
      end
    end

    describe 'GET-list of support tickets' do
      let(:support_ticket1) { create(:support_ticket) }
      let(:support_ticket2) { create(:support_ticket) }

      it 'successfully returns the all support tickets' do
        get :index
        expect(response.status).to eq 200
        expect(JSON.parse(response.body).size).to eq(SupportTicket.count)
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:support_ticket) { create(:support_ticket) }
    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      put :update, params: { id: support_ticket.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: support_ticket.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: support_ticket.id }
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
