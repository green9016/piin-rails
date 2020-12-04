# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe 'Associations for schedule' do
    it 'belongs to scheduleable' do
      assc = described_class.reflect_on_association(:scheduleable)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations for Schedule' do
    let(:firm) { create(:firm) }
    subject { described_class.new(scheduleable_type: 'Firm', scheduleable_id: firm.id, week_day: firm.id, starts: Date.today, ends: Date.today + 2.day) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without week_day' do
      subject.week_day = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without starts' do
      subject.starts = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without ends' do
      subject.ends = nil
      expect(subject).to_not be_valid
    end
  end
end
