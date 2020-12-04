# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::PinsController, type: :controller do
  describe 'When authorization headers is present' do
    let(:user) { create(:user) }
    before do
      @request.headers['Authorization'] = "Bearer #{user.token&.key}"
    end

    describe 'POST-move_location pin' do
      let(:pin) { create(:pin) }
      let(:valid_params) do
        {
          'id' => pin.id,
          'latitude' => Faker::Address.latitude,
          'longitude' => Faker::Address.longitude
        }
      end
      let(:invalid_params) do
        {
          'id' => pin.id,
          'latitude' => '',
          'longitude' => ''
        }
      end

      context 'when parameters are valid' do
        it 'successfully create a pin record' do
          post :move_location, params: valid_params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
        end
      end

      context 'when parameters are invalid' do
        it 'return with validation error' do
          post :move_location, params: invalid_params
          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include('Validation failed: ')
        end
      end

      context 'when parameters are invalid' do
        it 'return with not found error' do
          post :move_location, params: { id: 'abc' }
          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Pin with 'id'")
        end
      end
    end

    describe 'Post-visit visited_location' do
      let(:pin1) { create(:pin) }
      let(:valid_params) do
        {
          'id' => pin1.id,
          'lat' => Faker::Address.latitude,
          'lng' => Faker::Address.longitude
        }
      end

      let(:invalid_params) do
        {
          'id' => '',
          'lat' => '',
          'lng' => ''
        }
      end

      context 'when parameters are valid' do
        it 'successfully create a visited_location record' do
          post :visit, params: valid_params
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/json'
        end
      end

      context 'when pin id is blank' do
        it 'return with validation error' do
          post :visit, params: invalid_params
          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Couldn't find Pin with 'id'")
        end
      end

      context 'when lat and lng are invalid' do
        it 'return with validation error' do
          invalid_params[:id] = pin1.id
          post :visit, params: invalid_params
          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/json'
          expect(JSON.parse(response.body)['message']).to include("Validation failed: Lat can't be blank, Lng can't be blank")
        end
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:pin) { create(:pin) }
    it 'returns token error when move_location is called' do
      post :move_location, params: { 'id' => pin.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end

    it 'returns token error when move_location is called' do
      post :visit, params: { 'id' => pin.id }
      expect(response.status).to eq 403
      expect(JSON.parse(response.body)['message']).to eq('Token not found!')
    end
  end
end
