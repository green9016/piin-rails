# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feature, type: :model do
  describe 'Associations' do
    it 'has many flags' do
      assc = described_class.reflect_on_association(:flags)
      expect(assc.macro).to eq :has_many
    end

    it 'has_many firms' do
      assc = described_class.reflect_on_association(:firms)
      expect(assc.macro).to eq :has_many
    end
  end

  describe 'Validations' do
    subject do
      described_class.new(icon: 'dsfds3sda',
                          name: 'feature_name_updated11',
                          description: 'description5')
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without icon' do
      subject.icon = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without icon' do
      subject.icon = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without name' do
      feature = Feature.create(icon: 'dsfds3sda',
                               name: 'feature_name_updated11',
                               description: 'description5')
      expect(subject).to_not be_valid
    end

    it 'is not valid without description' do
      subject.description = nil
      expect(subject).to_not be_valid
    end
  end
end
