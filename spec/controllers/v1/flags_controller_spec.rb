# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::FlagsController, type: :controller do
  describe 'When authorization headers is present' do
    let(:user) { create(:user) }
    before do
      @request.headers['Authorization'] = "Bearer #{user.get_token&.key}"
    end

    describe 'Post-create for flag' do
      let(:firm) { create(:firm) }
      let(:feature) { create(:feature) }
      let(:valid_params) { FactoryBot.attributes_for(:flag, firm_id: firm.id, feature_id: feature.id) }
      let(:blank_params) do
        {
          'active' => '',
          'firm_id' => '',
          'feature_id' => ''
        }
      end

      context 'when parameters are valid' do
        it 'Successfully create a flag' do
          post :create, params: valid_params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
        end
      end

      context 'when parameters are invalid' do
        it 'return error' do
          post :create, params: blank_params
          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('Validation failed: Feature must exist, Firm must exist')
        end
      end

      context 'when parameters are already exist' do
        let(:flag) { create(:flag, firm_id: firm.id, feature_id: feature.id) }
        it 'return error' do
          blank_params[:firm_id] = flag.firm_id
          blank_params[:feature_id] = flag.feature_id
          post :create, params: blank_params
          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('Validation failed: Feature has already been taken')
        end
      end
    end

    describe 'Patch-update for flag' do
      let(:flag) { create(:flag) }
      let(:params) do
        {
          'active' => 1,
          'id' => flag.id
        }
      end

      context 'when parameters are valid' do
        it 'Successfully update the flag' do
          patch :update, params: params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['active']).to eq flag.active
        end
      end

      context 'when parameters are invalid' do
        it 'return error' do
          params[:active] = ' '
          put :update, params: params
          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to eq "Active value can't be null"
        end
      end

      context 'when parameters are having invalid value' do
        it 'return error' do
          params[:id] = 'abc'
          put :update, params: params
          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Flag with 'id'")
        end
      end
    end

    describe 'Get-show for flag' do
      let(:flag) { create(:flag) }
      let(:valid_params) { { id: flag.id } }
      let(:invalid_params) { { id: 'abc' } }

      context 'when parameters are valid' do
        it 'Successfully show the flag' do
          get :show, params: valid_params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['active']).to eq flag.active
        end
      end

      context 'when parameters are invalid' do
        it 'return error' do
          get :show, params: invalid_params
          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Flag with 'id'")
        end
      end
    end

    describe 'Delete-destroy for flag' do
      let(:flag) { create(:flag) }
      let(:valid_params) { { id: flag.id } }
      let(:invalid_params) { { id: 'abc' } }

      context 'when parameters are valid' do
        it 'Successfully destroy the flag' do
          delete :destroy, params: valid_params
          expect(response.status).to eq 204
        end
      end

      context 'when parameters are invalid' do
        it 'return error' do
          delete :destroy, params: invalid_params
          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Flag with 'id'")
        end
      end
    end

    describe 'Flag list' do
      let(:firm) { create(:firm) }
      let!(:flag1) { create(:flag, firm_id: firm.id) }
      let!(:flag2) { create(:flag) }

      context 'when post is passed to index' do
        it 'successfully get all flags of post_id' do
          get :index, params: { firm_id: firm.id }
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body).size).to eql 1
        end
      end
      context 'when flag is passed to index' do
        it 'successfully get all flag' do
          get :index
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body).size).to eql Flag.count
        end
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:flag) { create(:flag) }

    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      patch :update, params: { id: flag.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: flag.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: flag.id }
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
