# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business, type: :model do
  let(:business) { create(:business) }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:encrypted_password) }
  it { is_expected.to respond_to(:reset_password_token) }
  it { is_expected.to respond_to(:reset_password_sent_at) }
  it { is_expected.to respond_to(:remember_created_at) }
  it { is_expected.to respond_to(:sign_in_count) }
  it { is_expected.to respond_to(:current_sign_in_at) }
  it { is_expected.to respond_to(:last_sign_in_at) }
  it { is_expected.to respond_to(:current_sign_in_ip) }
  it { is_expected.to respond_to(:last_sign_in_ip) }
  it { is_expected.to respond_to(:confirmation_token) }
  it { is_expected.to respond_to(:confirmed_at) }
  it { is_expected.to respond_to(:confirmation_sent_at) }
  it { is_expected.to respond_to(:username) }
  it { is_expected.to respond_to(:photo) }
  it { is_expected.to respond_to(:first_name) }
  it { is_expected.to respond_to(:last_name) }
  it { is_expected.to respond_to(:birthday) }
  it { is_expected.to respond_to(:facebook_token) }
  it { is_expected.to respond_to(:lat) }
  it { is_expected.to respond_to(:lng) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:discarded_at) }

  describe 'Associations' do
    it { is_expected.to have_many(:support_tickets).dependent(:destroy) }
    it { is_expected.to have_many(:pins) }
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_one(:owned_firm).class_name('Firm') }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  it { is_expected.to accept_nested_attributes_for(:owned_firm).allow_destroy(false) }
end
