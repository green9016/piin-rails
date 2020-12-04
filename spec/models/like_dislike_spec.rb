# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LikeDislike, type: :model do
  describe 'Associations' do
    it 'belongs to user' do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to post' do
      assc = described_class.reflect_on_association(:post)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }
    subject { described_class.new(post_id: post.id, user_id: user.id) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without user_id' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without post_id' do
      subject.post_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid when create with same post_id and user_id' do
      like_dislike = LikeDislike.create(user_id: user.id, post_id: post.id)
      expect(subject).to_not be_valid
    end
  end

  context 'returns the amount of likes' do
    let(:post) { create(:post) }
    let(:user) {  create(:user) }
    let(:like_dislike) { create(:like_dislike, is_like: true, post_id: post.id, user_id: user.id) }

    it { expect(LikeDislike.like) == %i[like_dislike] }
    it { expect(LikeDislike.like).not_to be_nil }
  end
  
  context 'returns the amount of dislikes' do
    let(:post) { create(:post) }
    let(:user) {  create(:user) }
    let(:like_dislike) { create(:like_dislike, is_like: false, post_id: post.id, user_id: user.id) }

    it { expect(LikeDislike.like) == %i[like_dislike] }
    it { expect(LikeDislike.like).not_to be_nil }
  end
end
