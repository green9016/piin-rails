# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pin, type: :model do
  let(:pin) { build(:pin) }

  it { expect(pin).to respond_to(:id) }
  it { expect(pin).to respond_to(:firm_id) }
  it { expect(pin).to respond_to(:icon) }
  it { expect(pin).to respond_to(:colour) }
  it { expect(pin).to respond_to(:range) }
  it { expect(pin).to respond_to(:duration) }
  it { expect(pin).to respond_to(:daily_price_in_cents) }
  it { expect(pin).to respond_to(:lat) }
  it { expect(pin).to respond_to(:lng) }
  it { expect(pin).to respond_to(:status) }

  describe 'Associations' do
    it { is_expected.to belong_to(:firm) }
    it { is_expected.to belong_to(:business) }
    it { is_expected.to have_many(:visited_locations).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:visited_locations) }
    it { is_expected.to have_many(:purchases).dependent(:destroy) }
    it { is_expected.to have_many(:offers).through(:firm) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:icon) }
    it { is_expected.to validate_presence_of(:colour) }
    it { is_expected.to validate_presence_of(:range) }
    it { is_expected.to validate_presence_of(:duration) }
    it { is_expected.to validate_presence_of(:daily_price_in_cents) }
    it { is_expected.to validate_presence_of(:lat) }
    it { is_expected.to validate_presence_of(:lng) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe '#consumed_days' do
    it 'returns how many days have passed since Pin activation' do
      pin.activated_on = Time.zone.now

      Timecop.freeze(Time.zone.now + 4.days) do
        expect(pin.consumed_days).to eq(5)
      end
    end
  end

  describe '#consumed_balance' do
    it 'returns consumed_balance since Pin activation' do
      pin = create(:pin, daily_price_in_cents: 15)

      pin.activated_on = Time.zone.now

      Timecop.freeze(Time.zone.now + 4.days) do
        expect(pin.consumed_balance).to eq(75)
      end
    end
  end

  describe '#remaining_balance' do
    it 'returns remaining_balance sice Pin activation' do
      pin = create(:pin, daily_price_in_cents: 15, initial_balance_in_cents: 2)

      pin.activated_on = Time.zone.now

      Timecop.freeze(Time.zone.now + 4.days) do
        expect(pin.remaining_balance).to eq(-73)
      end
    end
  end
end
