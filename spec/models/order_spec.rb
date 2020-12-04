# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to respond_to(:firm_id) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:code) }
  it { is_expected.to respond_to(:value) }
  it { is_expected.to respond_to(:stripe_charge_token) }
  it { is_expected.to respond_to(:stripe_charge_status) }
  it { is_expected.to respond_to(:stripe_charge_message) }
  it { is_expected.to respond_to(:status) }

  describe 'Associations' do
    it 'belongs_to firm' do
      assc = described_class.reflect_on_association(:firm)
      expect(assc.macro).to eq :belongs_to
    end
    it 'belongs_to user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:firm) { create(:firm) }
    let (:user) { create(:user) }
    subject do
      described_class.new(code: 'hello', value: 1.05, stripe_charge_token: 'haiii',
                          stripe_charge_status: 'pending', status: 1,
                          stripe_charge_message: 'processing', firm_id: firm.id, user_id: user.id)
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is valid without code' do
      subject.code = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid uniqueness for code ' do
      order = Order.create(code: 'hello', value: 1.05, stripe_charge_token: 'haiii1',
                           stripe_charge_status: 'pending', status: 1,
                           stripe_charge_message: 'processing', firm_id: firm.id, user_id: user.id)
      expect(subject).to_not be_valid
    end

    it 'is not valid uniqueness for  stripe_charge_token ' do
      order = Order.create(code: 'hello1', value: 1.05, stripe_charge_token: 'haiii',
                           stripe_charge_status: 'pending', status: 1,
                           stripe_charge_message: 'processing', firm_id: firm.id, user_id: user.id)
      expect(subject).to_not be_valid
    end

    it 'is valid without value' do
      subject.value = nil
      expect(subject).to_not be_valid
    end

    it 'is valid without status' do
      subject.status = nil
      expect(subject).to_not be_valid
    end

    it 'is valid without firm' do
      subject.firm = nil
      expect(subject).to_not be_valid
    end

    it 'is valid without user' do
      subject.user = nil
      expect(subject).to_not be_valid
    end

    it 'is valid without stripe_charge_status' do
      subject.stripe_charge_status = nil
      expect(subject).to_not be_valid
    end

    it 'is valid without stripe_charge_token' do
      subject.stripe_charge_token = nil
      expect(subject).to_not be_valid
    end
  end

  it '#enum status' do
    is_expected.to define_enum_for(:status).with_values(%i[active inactive])
  end
end
