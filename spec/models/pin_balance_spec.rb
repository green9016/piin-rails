require 'rails_helper'

RSpec.describe PinBalance, type: :model do
  let(:pin_balance) { build(:pin_balance) }

  it { is_expected.to respond_to(:pin) }
  it { is_expected.to respond_to(:firm) }
  it { is_expected.to respond_to(:amount_in_cents) }

  describe 'Associations' do
    it { is_expected.to belong_to(:pin).inverse_of(:pin_balance) }
    it { is_expected.to belong_to(:firm).inverse_of(:pin_balances) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:pin) }
    it { is_expected.to validate_presence_of(:firm) }
    it { is_expected.to validate_presence_of(:amount_in_cents) }
  end
end
