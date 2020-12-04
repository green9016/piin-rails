# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'Associations' do
    it 'belongs_to post' do
      assc = described_class.reflect_on_association(:post)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:post) { create(:post) }
    subject do
      described_class.new(post_id: post.id, title: 'post_title',
                          week_days: '[0, 1, 2]',
                          price: 10.0, percent: 50, status: 'active')
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without description' do
      subject.post_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without status' do
      subject.status = nil
      expect(subject).to_not be_valid
    end
  end

  describe '#prepare_week_days' do
    context 'when week_days is valid' do
      let(:offer) { create(:offer, week_days: [0, 1, 2, 3]) }
      it { expect(offer.week_days).to be == ["0", "1", "2", "3"] }
      
      context 'uniq week days' do
        let(:offer) { create(:offer, week_days: [0, 1, 2, 3, 3, 3]) }
        it { expect(offer.week_days.uniq).to be == ["0", "1", "2", "3"] }
      end
    end
  end

  describe '#validate_week_days' do
    it 'when week_days is blank' do
      offer = build(:offer, week_days: '')
      offer.valid?
      expect(offer.errors[:week_days]).to include('cannot be empty')
    end

    it 'when week_days has a negative number' do
      offer = build(:offer, week_days: [0, 1, 2, -3])
      offer.valid?
      expect(offer.errors[:week_days]).to include('has invalid days')
    end
  end
end
