# frozen_string_literal: true

require 'rails_helper'

RSpec.describe View, type: :model do
  describe 'Associations' do
    it 'belongs_to user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs_to post' do
      assc = described_class.reflect_on_association(:post)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    subject { described_class.new(user_id: user.id, post_id: post.id) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without user' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without post' do
      subject.post_id = nil
      expect(subject).to_not be_valid
    end
  end
end
