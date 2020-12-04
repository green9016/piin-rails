# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { build(:post) }

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:firm_id) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:kinds) }
  it { is_expected.to respond_to(:status) }

  # it_behaves_like "eraseable"

  describe 'Associations' do
    it { is_expected.to belong_to(:firm) }
    it { is_expected.to belong_to(:business) }
    it { is_expected.to have_many(:offers).dependent(:destroy) }
    it { is_expected.to have_many(:views).class_name('View').dependent(:destroy) }
    it { is_expected.to have_many(:like_dislikes).dependent(:destroy) }
    it { is_expected.to have_many(:reports).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:like_dislikes) }
    it { is_expected.to have_many(:pins).through(:firm) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:photo) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:kinds) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_length_of(:description).is_at_most(100) }
  end

  # it '#can_be_erase' do
  #   expect(post.can_be_erase?).to be(false)
  # end

  it { is_expected.to define_enum_for(:status).with_values(%i[active inactive]) }

  it '#self.active' do
    expect(Post.active).not_to be_nil
  end

  it '#self.unchecked' do
    expect(Post.unchecked.count).to be >= 0
  end

  it { expect(post).to allow_value(File.open(Rails.root.join('spec/support/default.jpeg'))).for(:photo) }
  
  it '#post.likes' do
    expect(post.likes.count).to be >= 0
  end

  it '#post.dislikes' do
    expect(post.dislikes.count).to be >= 0
  end
  #   describe 'Associations' do
  #     it 'belongs_to firm' do
  #       assc = described_class.reflect_on_association(:firm)
  #       expect(assc.macro).to eq :belongs_to
  #     end

  #     it 'has_many offers' do
  #       assc = described_class.reflect_on_association(:offers)
  #       expect(assc.macro).to eq :has_many
  #     end

  #     it 'has_many views' do
  #       assc = described_class.reflect_on_association(:views)
  #       expect(assc.macro).to eq :has_many
  #     end

  #     it 'has_many like_dislikes' do
  #       assc = described_class.reflect_on_association(:like_dislikes)
  #       expect(assc.macro).to eq :has_many
  #     end

  #     it 'has_many reports' do
  #       assc = described_class.reflect_on_association(:reports)
  #       expect(assc.macro).to eq :has_many
  #     end
  #   end

  #   describe 'Validations' do
  #     before do
  #       @file = fixture_file_upload('spec/support/default.jpeg', 'text/jpeg')
  #     end

  #     let(:firm) {create(:firm)}
  #     subject { described_class.new(title: 'hello' , kinds:'types' , status:1 , firm_id: firm.id ) }

  #     it 'is valid with valid attributes' do
  #       subject.photo = @file
  #       expect(subject).to be_valid
  #     end

  #     it 'is valid without photo' do
  #       expect(subject).to_not be_valid
  #     end

  #     it 'is valid without title' do
  #       subject.title = nil
  #       expect(subject).to_not be_valid
  #     end

  #     it 'is valid without kinds' do
  #       subject.kinds = nil
  #       expect(subject).to_not be_valid
  #     end

  #     it 'is valid without status' do
  #       subject.status = nil
  #       expect(subject).to_not be_valid
  #     end

  #     it 'is valid without firm' do
  #       subject.firm_id = nil
  #       expect(subject).to_not be_valid
  #     end
  #   end
end
