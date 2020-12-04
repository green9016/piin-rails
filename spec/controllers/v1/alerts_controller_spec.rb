# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::AlertsController, type: :request do
  describe 'When authorization headers is present' do
    let(:user) { create(:user) }
    let(:headers) { { 'Authorization' => "Bearer #{user.token&.key}" } }

    let(:notification) { create(:notification) }

    describe 'Create Alert' do
      let(:params) { FactoryBot.attributes_for(:alert, notification: notification) }

      context 'when parameters are valid' do
        it 'successfully creates an alert record' do
          post v1_notification_alerts_path(notification_id: notification.id), params: params, headers: headers

          expect(response.status).to eq 201
          expect(response.content_type).to eq 'application/vnd.api+json'
        end
      end

      context 'when creating alert for same notification' do
        let!(:alert) { create(:alert, user: user, notification: notification) }

        it 'returns with error' do
          post v1_notification_alerts_path(notification_id: notification.id), params: params, headers: headers

          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/vnd.api+json'
          expect(JSON.parse(response.body)['errors'][0]['detail']).to include('Notification has already been taken')
        end
      end

      context 'when Notification does not exist' do
        it 'returns with error' do
          post v1_notification_alerts_path(notification_id: 'abc'), params: params, headers: headers

          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/vnd.api+json'
          expect(JSON.parse(response.body)['errors'][0]['detail']).to include("Couldn't find Notification with 'id'=abc")
        end
      end
    end

    describe 'Update Alert' do
      let!(:alert) { create(:alert, notification: notification) }
      let(:params) { { active: 'false' } }

      context 'when parameters are valid' do
        it 'successfully update the record' do
          expect(alert.reload.active).to be_truthy

          patch v1_notification_alert_path(notification_id: notification.id, id: alert.id), params: params, headers: headers

          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
          expect(JSON.parse(response.body)['data']['attributes']['active']).to eq(false)

          expect(alert.reload.active).to be_falsey
        end
      end

      context 'when "active" param is missing' do
        let(:params) { {} }

        it 'returns error' do
          expect(alert.reload.active).to be_truthy

          patch v1_notification_alert_path(notification_id: notification.id, id: alert.id), params: params, headers: headers

          expect(response.status).to eq 422
          expect(response.content_type).to eq 'application/vnd.api+json'
          expect(JSON.parse(response.body)['errors'][0]['detail']).to eq 'param is missing or the value is empty: active'

          expect(alert.reload.active).to be_truthy
        end
      end

      context 'when Alert does not exist' do
        it 'returns error' do
          expect(alert.reload.active).to be_truthy

          patch v1_notification_alert_path(notification_id: notification.id, id: 'x'), params: params, headers: headers

          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/vnd.api+json'
          expect(JSON.parse(response.body)['errors'][0]['detail']).to include("Couldn't find Alert with 'id'")

          expect(alert.reload.active).to be_truthy
        end
      end
    end

    describe 'Delete Alert' do
      let!(:alert) { create(:alert, notification: notification) }

      context 'when Alert exists' do
        it 'successfully deletes the alert' do
          delete v1_notification_alert_path(notification_id: notification.id, id: alert.id), headers: headers

          expect(response.status).to eq 204
          expect(Alert.find_by(id: alert.id)).to be_nil
        end
      end

      context 'when Alert does not exist' do
        it 'returns with error' do
          delete v1_notification_alert_path(notification_id: notification.id, id: 'x'), headers: headers

          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/vnd.api+json'
          expect(JSON.parse(response.body)['errors'][0]['detail']).to include("Couldn't find Alert with 'id'")
        end
      end
    end

    describe 'Show Alert' do
      let!(:alert) { create(:alert, notification: notification) }

      context 'when Alert exists' do
        it 'returns the alert' do
          get v1_notification_alert_path(notification_id: notification.id, id: alert.id), headers: headers

          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
          expect(JSON.parse(response.body)['data']['id']).to eq(alert.id.to_s)
          expect(JSON.parse(response.body)['data']['type']).to eq('alerts')
          expect(JSON.parse(response.body)['data']['attributes']['active']).to eq(true)
        end
      end

      context 'when Alert does not exist' do
        it 'returns with error' do
          get v1_notification_alert_path(notification_id: notification.id, id: 'x'), headers: headers

          expect(response.status).to eq 404
          expect(response.content_type).to eq 'application/vnd.api+json'
          expect(JSON.parse(response.body)['errors'][0]['detail']).to include("Couldn't find Alert with 'id'")
        end
      end
    end

    describe 'List Alerts' do
      let(:notification2) { create(:notification) }
      let!(:alert1) { create(:alert, active: false, user: user, notification: notification) }
      let!(:alert2) { create(:alert, user: user, notification: notification2) }
      let!(:alert3) { create(:alert, active: false, user: create(:user), notification: notification) }
      let!(:alert4) { create(:alert, user: create(:user), notification: notification) }

      context 'when active param is absent' do
        it 'successfully returns the current user alerts' do
          get v1_notification_alerts_path(notification_id: notification.id), headers: headers

          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'

          expect(JSON.parse(response.body)['data'].size).to eq(2)
          expect(JSON.parse(response.body)['data'][0]['id']).to eq(alert1.id.to_s)
          expect(JSON.parse(response.body)['data'][0]['type']).to eq('alerts')
          expect(JSON.parse(response.body)['data'][0]['attributes']['active']).to eq(false)
          expect(JSON.parse(response.body)['data'][1]['id']).to eq(alert2.id.to_s)
          expect(JSON.parse(response.body)['data'][1]['type']).to eq('alerts')
          expect(JSON.parse(response.body)['data'][1]['attributes']['active']).to eq(true)
        end
      end

      context 'when active param is passed true' do
        it 'successfully returns the current user active alerts' do
          get v1_notification_alerts_path(notification_id: notification.id, active: true), headers: headers

          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'

          expect(JSON.parse(response.body)['data'].size).to eq(1)
          expect(JSON.parse(response.body)['data'][0]['id']).to eq(alert2.id.to_s)
          expect(JSON.parse(response.body)['data'][0]['type']).to eq('alerts')
          expect(JSON.parse(response.body)['data'][0]['attributes']['active']).to eq(true)
        end
      end

      context 'when active param is passed false' do
        it 'successfully returns the current user inactive alerts' do
          get v1_notification_alerts_path(notification_id: notification.id, active: false), headers: headers

          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'

          expect(JSON.parse(response.body)['data'].size).to eq(1)
          expect(JSON.parse(response.body)['data'][0]['id']).to eq(alert1.id.to_s)
          expect(JSON.parse(response.body)['data'][0]['type']).to eq('alerts')
          expect(JSON.parse(response.body)['data'][0]['attributes']['active']).to eq(false)
        end
      end
    end
  end

  describe 'When authorization headers is not present' do
    let(:notification) { create(:notification) }
    let(:alert) { create(:alert, notification: notification) }

    it 'returns token error when create is called' do
      post v1_notification_alerts_path(notification_id: notification.id)

      expect(response.status).to eq 403
      expect(response.content_type).to eq 'application/vnd.api+json'
      expect(JSON.parse(response.body)['errors'][0]['detail']).to include('Token not found')
    end

    it 'returns token error when update is called' do
      patch v1_notification_alert_path(notification_id: notification.id, id: alert.id)

      expect(response.status).to eq 403
      expect(response.content_type).to eq 'application/vnd.api+json'
      expect(JSON.parse(response.body)['errors'][0]['detail']).to include('Token not found')
    end

    it 'returns token error when show is called' do
      get v1_notification_alert_path(notification_id: notification.id, id: alert.id)

      expect(response.status).to eq 403
      expect(response.content_type).to eq 'application/vnd.api+json'
      expect(JSON.parse(response.body)['errors'][0]['detail']).to include('Token not found')
    end

    it 'returns token error when delete is called' do
      delete v1_notification_alert_path(notification_id: notification.id, id: alert.id)

      expect(response.status).to eq 403
      expect(response.content_type).to eq 'application/vnd.api+json'
      expect(JSON.parse(response.body)['errors'][0]['detail']).to include('Token not found')
    end

    it 'returns token error when index is called' do
      get v1_notification_alerts_path(notification_id: notification.id)

      expect(response.status).to eq 403
      expect(response.content_type).to eq 'application/vnd.api+json'
      expect(JSON.parse(response.body)['errors'][0]['detail']).to include('Token not found')
    end
  end
end
