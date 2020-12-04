# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alert, type: :model do
  describe 'Associations' do
    it 'belongs to notification' do
      assc = described_class.reflect_on_association(:notification)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:notification) { create(:notification) }
    let(:user) { create(:user) }
    subject { described_class.new(notification_id: notification.id, user_id: user.id, active: false) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without user_id' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without notification_id' do
      subject.notification_id = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:notification_id).scoped_to(:user_id) }
  end
end
