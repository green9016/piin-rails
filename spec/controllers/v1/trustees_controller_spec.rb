# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::TrusteesController, type: :controller do
  describe 'When authorization headers is present' do
    let(:user) { create(:user) }
    before do
      @request.headers['Authorization'] = "Bearer #{user.get_token&.key}"
    end

    describe 'POST-create trustee' do
      let(:trustee) { create(:trustee, user_id: user.id) }
      let(:firm) { create(:firm) }
      let(:valid_params) { FactoryBot.attributes_for(:trustee, firm_id: firm.id, user_id: user.id) }
      let(:params_with_blank_val) do
        {
          'status' => '',
          'role' => ''
        }
      end

      context 'when parameters are valid' do
        it 'successfully create a trustee record' do
          post :create, params: valid_params
          expect(response.status).to eq 201
          expect(response.content_type).to eq 'application/json'
        end
      end

      context 'when parameters having invalid value' do
        it 'return with error' do
          params_with_blank_val[:firm_id] = 'abc'
          post :create, params: params_with_blank_val
          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Firm with 'id'")
        end
      end

      context 'when parameters are invalid' do
        it 'return with error' do
          params_with_blank_val[:firm_id] = trustee.firm_id
          params_with_blank_val[:user_id] = trustee.user_id
          post :create, params: params_with_blank_val
          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('Validation failed: Firm has already been taken')
        end
      end
    end

    describe 'PUT-update trustee' do
      let(:trustee) { create(:trustee) }
      let(:params) do
        {
          'id' => trustee.id,
          'status' => 2,
          'role' => 'user'
        }
      end

      context 'when parameters are valid' do
        it 'successfully update a trustee record' do
          put :update, params: params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['role']).to eq 'user'
        end
      end

      context 'when parameters are invalid' do
        it 'successfully update a user record' do
          params[:status] = ' '
          params[:role] = ' '
          put :update, params: params
          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to eq "Role or Status can't be null"
        end
      end
    end

    describe 'GET-show trustee' do
      let(:trustee) { create(:trustee) }
      let(:valid_params) { { id: trustee.id } }
      let(:invalid_params) { { id: 'abc' } }

      context 'when parameters are valid' do
        it 'successfully show the trustee' do
          get :show, params: valid_params
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['role']).to eq(trustee.role)
        end
      end

      context 'when parameters are not valid' do
        it 'returns with error' do
          get :show, params: invalid_params
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Trustee with 'id'")
        end
      end
    end

    describe 'DELETE-destroy trustee' do
      let(:trustee) { create(:trustee) }
      let(:valid_params) { { id: trustee.id } }
      let(:invalid_params) { { id: 'abc' } }

      context 'when parameters are valid' do
        it 'successfully delete the trustee' do
          delete :destroy, params: valid_params
          expect(response.status).to eq 204
        end
      end

      context 'when parameters are invalid' do
        it 'returns with error' do
          delete :destroy, params: invalid_params
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Trustee with 'id'")
        end
      end
    end

    describe 'GET-list of trustees' do
      let!(:trustee1) { create(:trustee, role: 'user', user_id: user.id) }
      let!(:trustee2) { create(:trustee, role: 'admin', user_id: user.id) }

      context 'when we does not pass role as a parameter' do
        it 'successfully get all trustees' do
          get :index
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body).size).to eql(Trustee.count)
        end
      end

      context 'when role admin is passed as a parameter' do
        it 'successfully get all trustees of admin role' do
          get :index, params: { role: 'admin' }
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)[0]['id']).to eql(trustee2.id)
        end
      end

      context 'when role user is passed as a parameter' do
        it 'successfully get all trustees of user role' do
          get :index, params: { role: 'user' }
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)[0]['id']).to eql(trustee1.id)
        end
      end
    end
  end
end
