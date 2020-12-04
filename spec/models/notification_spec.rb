# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Associations' do
    it 'has_many alerts' do
      assc = described_class.reflect_on_association(:alerts)
      expect(assc.macro).to eq :has_many
    end

    it 'has_many users' do
      assc = described_class.reflect_on_association(:users)
      expect(assc.macro).to eq :has_many
    end
  end

  describe 'Validations' do
    subject do
      described_class.new(name: 'name-12', description: 'description-2',
                          business: true)
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without description' do
      subject.description = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without business' do
      subject.business = false
      expect(subject).to_not be_valid
    end

    it 'is not valid without uniqueness in name' do
      like_dislike = Notification.create(name: 'name-12', description: 'description', business: true)
      expect(subject).to_not be_valid
    end
  end
end
