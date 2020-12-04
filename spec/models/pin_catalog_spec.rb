require 'rails_helper'

RSpec.describe PinCatalog, type: :model do
  let(:pin_catalog) { build(:pin_catalog) }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:banner) }
  it { is_expected.to respond_to(:icon) }
  it { is_expected.to respond_to(:color) }
  it { is_expected.to respond_to(:miles) }
  it { is_expected.to respond_to(:range) }
  it { is_expected.to respond_to(:duration_in_days) }
  it { is_expected.to respond_to(:daily_price_in_cents) }
  it { is_expected.to respond_to(:discarded_at) }

  describe 'Associations' do
    it { is_expected.to have_many(:pins).inverse_of(:pin_catalog) }
    it { is_expected.to have_many(:firms).through(:pins) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:banner) }
    it { is_expected.to validate_presence_of(:icon) }
    it { is_expected.to validate_presence_of(:color) }
    it { is_expected.to validate_presence_of(:miles) }
    it { is_expected.to validate_presence_of(:range) }
    it { is_expected.to validate_presence_of(:duration_in_days) }
    it { is_expected.to validate_presence_of(:daily_price_in_cents) }
  end

  it { expect(pin_catalog).to allow_value(File.open(Rails.root.join('spec/support/default.jpeg'))).for(:banner) }
end
