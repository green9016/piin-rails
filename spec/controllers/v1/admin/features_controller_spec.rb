# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Admin::FeaturesController, type: :controller do
  describe 'When authorization headers is present' do
    describe 'when authorized user is admin' do
      let(:user) { FactoryBot.create(:user, role_id: role.id) }
      before do
        @request.headers.merge!(user.create_new_auth_token)
      end

      describe 'POST-create feature' do
        let(:valid_params) { FactoryBot.attributes_for(:feature) }
        let(:invalid_params) do
          { name: '', description: '', icon: '' }
        end
        context 'when parameters are valid' do
          it 'successfully create a feature record' do
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

      describe 'PUT-update feature' do
        let(:feature) { FactoryBot.create(:feature) }
        let(:params) do
          { id: feature.id, name: 'newfeature' }
        end

        let(:invalid_params) do
          { id: 'abc', name: 'newfeature' }
        end

        context 'when parameters are valid' do
          it 'successfully update a feature record' do
            put :update, params: params
            expect(response.status).to eq 200
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['name']).to eq 'newfeature'
          end
        end

        context 'when parameters are not valid' do
          it 'returns error' do
            put :update, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Feature with 'id'")
          end
        end
      end

      describe 'DELETE-delete feature' do
        let(:feature) { FactoryBot.create(:feature) }
        let(:valid_params) { { id: feature.id } }
        let(:invalid_params) { { id: 'abc' } }

        context 'when parameters are valid' do
          it 'successfully delete the feature' do
            delete :destroy, params: valid_params
            expect(response.status).to eq 204
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            delete :destroy, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Feature with 'id'")
          end
        end
      end

      describe 'GET-show feature' do
        let(:feature) { FactoryBot.create(:feature) }
        let(:valid_params) { { id: feature.id } }
        let(:invalid_params) { { id: 'abc' } }

        context 'when parameters are valid' do
          it 'successfully returns the feature' do
            get :show, params: valid_params
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['name']).to eq(feature.name)
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            get :show, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Feature with 'id'")
          end
        end
      end

      describe 'GET-list of features' do
        let!(:feature1) { FactoryBot.create(:feature) }
        let!(:feature2) { FactoryBot.create(:feature) }

        it 'successfully returns the all features' do
          get :index
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data'].size).to eq(Feature.count)
        end
      end
    end

    describe 'when authorized user is not admin' do
      let(:role1) { FactoryBot.create(:role, name: 'user') }
      let(:user1) { FactoryBot.create(:user, role_id: role1.id) }
      before do
        @request.headers['Authorization'] = "Bearer #{user1.token&.key}"
      end

      describe 'POST-create user' do
        let(:valid_params) { FactoryBot.attributes_for(:feature) }

        it 'return unauthorized error' do
          post :create, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'PUT-update' do
        let(:feature) { FactoryBot.create(:feature) }
        let(:valid_params) do
          {
            id: feature.id,
            name: 'feature_name'
          }
        end

        it 'return unauthorized error' do
          put :update, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'GET-show' do
        let(:feature) { FactoryBot.create(:feature) }
        let(:valid_params) do
          { id: feature.id }
        end

        it 'return unauthorized error' do
          get :show, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'DELETE-destroy' do
        let(:feature) { FactoryBot.create(:feature) }
        let(:valid_params) do
          { id: feature.id }
        end

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
    let(:feature) { FactoryBot.create(:feature) }
    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      put :update, params: { id: feature.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: feature.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: feature.id }
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
