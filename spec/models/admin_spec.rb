# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  subject(:admin) { create(:admin) }

  it 'has a valid factory' do
    expect(admin).to be_valid
  end

  describe 'Validations' do
    let(:user) { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('admin@email.com').for(:email) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
  end

  describe '#name' do
    let(:user) { create(:user, email: 'johndoe@email.com') }

    it 'returns admin email' do
      expect(user.email).to eq('johndoe@email.com')
    end
  end

  describe 'create admin' do
    let(:result) do
      {
        'email' => 'johndoe2@example.com',
        'username' => 'johndoe2',
        'password' => '123456789'
      }
    end

    context 'when an admin with same email does not exist' do
      it 'creates a new admin with given attributes' do
        expect { Admin.new(result).save }.to change { Admin.count }.by(1)

        admin = Admin.last

        expect(admin.email).to eq('johndoe2@example.com')
        expect(admin.username).to eq('johndoe2')
      end
    end
  end
end
