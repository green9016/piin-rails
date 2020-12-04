# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'Associations' do
    it 'belongs_to user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs_to post' do
      assc = described_class.reflect_on_association(:post)
      expect(assc.macro).to eq :belongs_to
    end

    it { is_expected.to have_one(:firm).through(:post) }
  end

  describe 'Validations' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    subject { described_class.new(description: 'Anything', user_id: user.id, post_id: post.id) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without description' do
      subject.description = nil
      expect(subject).to_not be_valid
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

  it '#enum status' do
    is_expected.to define_enum_for(:status).with_values(%i[active inactive])
  end
end
