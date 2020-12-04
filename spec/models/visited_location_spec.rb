# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VisitedLocation, type: :model do
  describe 'Associations' do
    it 'belongs_to user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs_to pin' do
      assc = described_class.reflect_on_association(:pin)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:user) { create(:user) }
    let(:pin) { create(:pin) }
    subject { described_class.new(lat: 1.0, lng: 1.0, user_id: user.id, pin_id: pin.id) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without lat' do
      subject.lat = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without lng' do
      subject.lng = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without user' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without pin' do
      subject.pin_id = nil
      expect(subject).to_not be_valid
    end
  end
end
