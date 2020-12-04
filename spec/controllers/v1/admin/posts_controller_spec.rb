# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Admin::PostsController, type: :controller do
  describe 'When authorization headers is present' do
    describe 'when authorized user is admin' do
      let(:user) { create(:user, role: 'admin') }
      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'POST-create post' do
        let(:firm) { create(:firm) }
        let(:valid_params) { FactoryBot.attributes_for(:post).merge(firm_id: firm.id) }
        let(:invalid_params) do
          {
            'photo' => '',
            'title' => '',
            'kinds' => ''
          }
        end
        context 'when parameters are valid' do
          it 'successfully create a post record' do
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

      describe 'PUT-update popst' do
        let(:post) { create(:post) }
        let(:params) do
          {
            'id' => post.id,
            'kinds' => 'newkinds'
          }
        end

        let(:invalid_params) do
          {
            'id' => 'abc',
            'kinds' => 'newkinds'
          }
        end

        context 'when parameters are valid' do
          it 'successfully update a post record' do
            put :update, params: params
            expect(response.status).to eq 200
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['kinds']).to eq 'newkinds'
          end
        end

        context 'when parameters are invalid' do
          it 'return error' do
            put :update, params: invalid_params
            expect(response.status).to eq 404
            expect(response.content_type).to eq 'application/json'
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Post with 'id'")
          end
        end
      end

      describe 'DELETE-delete post' do
        let(:post) { create(:post) }
        let(:valid_params) { { 'id' => post.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully delete the post' do
            delete :destroy, params: valid_params
            expect(response.status).to eq 204
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            delete :destroy, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Post with 'id'")
          end
        end
      end

      describe 'GET-show post' do
        let(:post) { create(:post) }
        let(:valid_params) { { 'id' => post.id } }
        let(:invalid_params) { { 'id' => 'abc' } }

        context 'when parameters are valid' do
          it 'successfully returns the post' do
            get :show, params: valid_params
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['id']).to eq(post.id)
          end
        end

        context 'when parameters are not valid' do
          it 'returns with error' do
            get :show, params: invalid_params
            expect(response.status).to eq 404
            expect(JSON.parse(response.body)['message']).to include("Couldn't find Post with 'id'")
          end
        end
      end

      describe 'GET-list of posts' do
        let(:post1) { create(:post) }
        let(:post2) { create(:post) }

        it 'successfully returns the all posts' do
          get :index
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data'].size).to eq(Post.count)
        end
      end
    end

    describe 'when authorized user is not admin' do
      let(:user) { create(:user) }

      before do
        @request.headers['Authorization'] = "Bearer #{user.token&.key}"
      end

      describe 'POST-create post' do
        let(:firm) { create(:firm) }
        let(:valid_params) { FactoryBot.attributes_for(:post).merge(firm_id: firm.id) }

        it 'return authorization error' do
          post :create, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'PUT-update post' do
        let(:post) { create(:post) }
        let(:valid_params) do
          {
            'id' => post.id,
            'kinds' => 'newkinds'
          }
        end

        it 'return authorization error' do
          put :update, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end

      describe 'DELETE-destroy post' do
        let(:post) { create(:post) }
        let(:valid_params) do
          {
            'id' => post.id
          }
        end

        it 'return authorization error' do
          delete :destroy, params: valid_params
          expect(response.status).to eq 401
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('You are not authorized to access this page.')
        end
      end
    end

    describe 'Search posts and offers' do
      # when create an offers, post is automatically created
      let(:offers) { create_list(:offer, 10) }

      it 'successfully perform search by offer title' do
        first_offer = offers[0]
        params = { search: first_offer.title }
        get :search, params: params
        res = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(res['total']).to be > 0
      end

      it 'successfully perform search by chunk of offer title' do
        # search by word
        first_offer = offers[0]
        word = first_offer.title.split(' ')[0]
        params = { search: word }
        get :search, params: params
        res = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(res['total']).to be > 0
      end

      it 'successfully perform search by post title' do
        first_offer = offers[0]
        params = { search: first_offer.post.title }
        get :search, params: params
        res = JSON.parse(response.body)
        expect(response.status).to eq 200
        expect(res['total']).to be > 0
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:new_post) { create(:post) }
    it 'returns token error when create is called' do
      post :create, params: {}
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when update is called' do
      put :update, params: { id: new_post.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when show is called' do
      get :show, params: { id: new_post.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when delete is called' do
      delete :destroy, params: { id: new_post.id }
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
