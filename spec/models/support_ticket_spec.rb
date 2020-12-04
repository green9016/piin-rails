# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SupportTicket, type: :model do
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:ticketable_id) }
  it { is_expected.to respond_to(:status) }

  describe 'Associations' do
    it 'belongs_to ticketable' do
      assc = described_class.reflect_on_association(:ticketable)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe 'Validations' do
    let(:user) { create(:user) }
    subject { described_class.new(status: 1, ticketable: user, query: 'Test') }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without status' do
      subject.status = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without ticktable' do
      subject.ticketable = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_length_of(:query).is_at_most(1500) }

    it '#enum status' do
      is_expected.to define_enum_for(:status).with_values(%i[unread pending solved])
    end

    it '#self.unchecked' do
      expect(SupportTicket.unchecked.count).to be >= 0
    end
  end
end
