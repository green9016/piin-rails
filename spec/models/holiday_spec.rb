# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Holiday, type: :model do
  describe 'Validations' do
    subject { described_class.new(title: 'title_description', from_date: Date.today, until_date: Date.today + 2.day, status: :active) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid because of uniqueness of title' do
      holiday = Holiday.create(title: 'title_description',
                               from_date: Date.today,
                               until_date: Date.today + 2.day, status: :active)
      expect(subject).to_not be_valid
    end

    it 'is not valid without from_date' do
      subject.from_date = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without until_date' do
      subject.until_date = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without status' do
      subject.status = nil
      expect(subject).to_not be_valid
    end
  end
  
  it { expect(subject).to allow_value(File.open(Rails.root.join('spec/support/default.jpeg'))).for(:post_photo) }
  it { expect(subject).to allow_value(File.open(Rails.root.join('spec/support/default.jpeg'))).for(:icon_photo) }
end
