# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trustee, type: :model do
  describe 'Associations' do
    it 'belongs_to user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs_to firm' do
      assc = described_class.reflect_on_association(:firm)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:user) { create(:user) }
    let(:firm) { create(:firm) }
    subject { described_class.new(role: 1, status: 1, user_id: user.id, firm_id: firm.id) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without role' do
      subject.role = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without status' do
      subject.status = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without user' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without firm' do
      subject.firm_id = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:firm_id).scoped_to(:user_id) }
  end

  it '#enum role' do
    is_expected.to define_enum_for(:role).with_values(%i[user admin])
  end
end
