# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flag, type: :model do
  describe 'Associations' do
    it 'belongs to feature' do
      assc = described_class.reflect_on_association(:feature)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to firm' do
      assc = described_class.reflect_on_association(:firm)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:feature) { create(:feature) }
    let(:firm) { create(:firm) }
    subject { described_class.new(firm_id: firm.id, feature_id: feature.id, active: true) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without user_id' do
      subject.firm_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without notification_id' do
      subject.feature_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without notification_id' do
      subject.active = false
      expect(subject).to_not be_valid
    end
  end
end
