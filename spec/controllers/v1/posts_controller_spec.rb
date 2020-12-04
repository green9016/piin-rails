# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PostsController, type: :controller do
  describe 'When authorization headers is present' do
    let(:user) { create(:user) }
    before do
      @request.headers['Authorization'] = "Bearer #{user.get_token&.key}"
    end

    describe 'GET-show post' do
      let(:post) { create(:post) }
      let(:valid_params) do
        {
          'id' => post.id
        }
      end

      context 'when parameters are valid' do
        it 'successfully show post' do
          get :show, params: valid_params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
        end

        it 'successfully returns post related data' do
          get :show, params: valid_params
          expect(response.status).to eq 200
          expect(JSON.parse(response.body).keys).to include('firm')
          expect(JSON.parse(response.body).keys).to include('offers')
          expect(JSON.parse(response.body)['firm'].keys).to include('schedules')
          expect(JSON.parse(response.body)['firm'].keys).to include('features')
        end
      end

      context 'when parameters are invalid' do
        it 'return error' do
          get :show, params: { id: '' }
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Post with 'id'")
        end
      end
    end

    describe 'POST-like post' do
      let(:post_record) { create(:post) }

      context 'when parameters are valid' do
        it 'successfully create a like record' do
          post :like, params: { id: post_record.id }
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['is_like']).to eq(true)
        end
      end

      context 'when parameters are invalid' do
        it 'returns error' do
          post :like, params: { id: '' }
          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Post with 'id'")
        end
      end
    end

    describe 'POST-dislike post' do
      let(:post_record) { create(:post) }
      context 'when parameters are valid' do
        it 'successfully create a dislike record' do
          post :dislike, params: { id: post_record.id }
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['is_like']).to eq(false)
        end
      end

      context 'when parameters are invalid' do
        it 'returns error' do
          post :dislike, params: { id: '' }
          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Post with 'id'")
        end
      end
    end
  end

  describe 'when authenticate token is invalid' do
    let(:post1) { create(:post) }
    it 'returns token error' do
      get :show, params: { 'id' => post1.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error' do
      post :like, params: { 'id' => post1.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error' do
      post :dislike, params: { 'id' => post1.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end
  end
end
