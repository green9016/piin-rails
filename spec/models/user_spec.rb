# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  describe 'Associations' do
    it { is_expected.to have_many(:support_tickets).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_many(:alerts).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).through(:alerts) }
    it { is_expected.to have_many(:trustees).dependent(:destroy) }
    it { is_expected.to have_many(:firms).through(:trustees) }
    it { is_expected.to have_many(:locations).dependent(:destroy) }
    it { is_expected.to have_many(:views).class_name('View').dependent(:destroy) }
    it { is_expected.to have_many(:purchases) }
    it { is_expected.to have_many(:visited_locations).dependent(:destroy) }
    it { is_expected.to have_many(:visited_pins).through(:visited_locations).source(:pin) }
    it { is_expected.to have_many(:like_dislikes).dependent(:destroy) }
    it { is_expected.to have_many(:purchases).dependent(:destroy) }
    it { is_expected.to have_many(:user_posts).through(:like_dislikes).source(:post) }
    it { is_expected.to have_many(:reports).dependent(:destroy) }
    it { is_expected.to have_many(:owned_firms).class_name('Firm').with_foreign_key(:owner_id) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    # it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_presence_of(:birthday) }
  end

  describe '#enum role' do
    it { is_expected.to define_enum_for(:role).with_values([:user, :business, :admin]) }
  end

  describe '#enum status' do
    it { is_expected.to define_enum_for(:status).with_values([:active, :inactive]) }
  end

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe '.create_user_from_fb' do
    # TODO, test with birthday empty?
    let(:result) do
      {
        'email' => 'johndoe@example.com',
        'photo'      => File.open(Rails.root.join('spec/support/default.jpeg')),
        'first_name' => 'John',
        'last_name' => 'Doe',
        'name' => 'John Doe',
        'birthday' => '1990-01-01'
      }
    end

    context 'when an user with same email already exists' do
      before do
        create(:user)
        @user = create(:user, email: 'johndoe@example.com')
        create(:user)
      end

      # it 'returns the existing user' do
      #   expect(User.create_user_from_fb(result)).to eq(@user)
      # end
    end

    # context 'when an user with same email does not exist' do
    #   it 'creates a new user with given attributes' do
    #     expect { User.create_user_from_fb(result) }.to change { User.count }.by(1)

    #     user = User.last

    #     expect(user.first_name).to eq('John')
    #     expect(user.last_name).to eq('Doe')
    #     expect(user.username).to eq('JohnDoe')
    #   end
    # end

    # it 'returns an User' do
    #   expect(User.create_user_from_fb(result)).to be_a(User)
    # end
  end

  describe '#name' do
    let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

    it 'returns user full name' do
      expect(user.name).to eq('John Doe')
    end
  end

  it '#likes' do
    expect(user.likes.count).to be >= 0
  end

  it '#liked_posts' do
    expect(user.liked_posts.count).to be >= 0
  end

  describe '#less_than_birthday' do
    it 'when the birthday is greater than the current date' do
      user = build(:user, birthday: (Date.current + 3.days))
      user.valid?
      expect(user.errors[:birthday]).to include('greater than or equal to current date!')
    end
    
    it 'when the birthday is equal than the current date' do
      user = build(:user, birthday: Date.current)
      user.valid?
      expect(user.errors[:birthday]).to include('greater than or equal to current date!')
    end
  end
  # describe '#token' do
  #   it 'returns a token' do
  #     expect(user.token).to be_a(Token)
  #   end

  #   context 'when tokens count is less than the limit' do
  #     before do
  #       create_list(:token, 2, user: user)
  #     end

  #     it 'creates a new token' do
  #       expect { user.token }.to change { user.reload.tokens.count }.by(1)
  #     end
  #   end

  #   context 'when tokens count is greater than the limit' do
  #     before do
  #       @user_tokens = create_list(:token, 3, user: user)
  #     end

  #     it 'does not create a new token' do
  #       expect { user.token }.to_not change { user.reload.tokens.count }
  #     end

  #     it 'renews an existing token' do
  #       tokens_double = double('User tokens', oldest: @user_tokens, count: 3)
  #       existing_token = @user_tokens.first

  #       allow(user).to receive(:tokens).and_return(tokens_double)

  #       allow(existing_token).to receive(:renew!)
  #       expect(existing_token).to receive(:renew!)

  #       user.token
  #     end
  #   end
  # end
end
