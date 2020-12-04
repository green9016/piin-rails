# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'Associations' do
    it 'belongs to user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:user) { create(:user) }
    subject { described_class.new(user_id: user.id, lat: 0.5, lng: 0.5) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without user_id' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without post_id' do
      subject.lat = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without post_id' do
      subject.lng = nil
      expect(subject).to_not be_valid
    end
  end
end
