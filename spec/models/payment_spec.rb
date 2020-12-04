require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { build(:payment) }
  
  it { is_expected.to respond_to(:business) }
  it { is_expected.to respond_to(:firm) }
  it { is_expected.to respond_to(:pin) }
  it { is_expected.to respond_to(:amount_in_cents) }

  describe 'Associations' do
    it { is_expected.to belong_to(:business) }
    it { is_expected.to belong_to(:firm) }
    it { is_expected.to belong_to(:pin) }
  end


  describe 'Validations' do
    it { is_expected.to validate_presence_of(:business) }
    it { is_expected.to validate_presence_of(:firm) }
    it { is_expected.to validate_presence_of(:pin) }
    it { is_expected.to validate_presence_of(:amount_in_cents) }
  end
end
