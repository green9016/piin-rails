# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Firm, type: :model do
  let(:firm) { build(:firm) }

  it { expect(firm).to respond_to(:photo) }
  it { expect(firm).to respond_to(:name) }
  it { expect(firm).to respond_to(:about) }
  it { expect(firm).to respond_to(:state) }
  it { expect(firm).to respond_to(:city) }
  it { expect(firm).to respond_to(:street) }
  it { expect(firm).to respond_to(:zip) }
  it { expect(firm).to respond_to(:lat) }
  it { expect(firm).to respond_to(:lng) }
  it { expect(firm).to respond_to(:status) }

  describe 'Associations' do
    it { is_expected.to have_many(:trustees).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:trustees) }
    it { is_expected.to have_many(:flags).dependent(:destroy) }
    it { is_expected.to have_many(:features).through(:flags) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:schedules).dependent(:destroy) }
    it { is_expected.to have_many(:pins).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    # it { is_expected.to have_many(:reports).through(:posts) }
    it { is_expected.to have_many(:offers).through(:posts) }
    it { is_expected.to belong_to(:owner).class_name('Business') }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:lat) }
    it { is_expected.to validate_presence_of(:lng) }
    it { is_expected.to validate_presence_of(:status) }
  end

  it 'enum status defined' do
    is_expected.to define_enum_for(:status).with_values(%i[active inactive])
  end

  describe '#self.unchecked' do
    it { expect(Firm.unchecked.count).to be(0) }
  end

  describe '#active_pins_count' do
    it { expect(firm.active_pins_count).to be >= 0 }
    it { expect(firm.active_pins_count).not_to be_nil }
  end
  
  describe '#reports_count' do
    it { expect(firm.reports_count).to be >= 0 }
    it { expect(firm.reports_count).not_to be_nil }
  end
  
  describe '#available_balance' do
    it { expect(firm.available_balance).to be >= 0 }
    it { expect(firm.available_balance).not_to be_nil }
  end

  it { expect(firm).to allow_value(File.open(Rails.root.join('spec/support/default.jpeg'))).for(:photo) }
  # describe 'Associations for Firm' do
  #   it 'has many trustees' do
  #     assc = described_class.reflect_on_association(:trustees)
  #     expect(assc.macro).to eq :has_many
  #   end

  #   it 'has_many user' do
  #     assc = described_class.reflect_on_association(:user)
  #     expect(assc.macro).to eq :has_many
  #   end

  #   it 'has_many flags' do
  #     assc = described_class.reflect_on_association(:flags)
  #     expect(assc.macro).to eq :has_many
  #   end

  #   it 'has_many features' do
  #     assc = described_class.reflect_on_association(:features)
  #     expect(assc.macro).to eq :has_many
  #   end

  #   it 'has_many posts' do
  #     assc = described_class.reflect_on_association(:posts)
  #     expect(assc.macro).to eq :has_many
  #   end

  #   it 'has_many schedules' do
  #     assc = described_class.reflect_on_association(:schedules)
  #     expect(assc.macro).to eq :has_many
  #   end

  #   it 'has_many pins' do
  #     assc = described_class.reflect_on_association(:pins)
  #     expect(assc.macro).to eq :has_many
  #   end

  #   it 'has_many orders' do
  #     assc = described_class.reflect_on_association(:orders)
  #     expect(assc.macro).to eq :has_many
  #   end
  # end

  # describe 'Validations' do

  #   before do
  #     @file = fixture_file_upload('spec/support/default.jpeg', 'text/jpeg')
  #   end

  #   subject {described_class.new(name: "firm_name",
  #                                about: "form_about", business: "adfas",
  #                                keywords: "sas", balance: 1.201,
  #                                state: "state", city: "dfg", street: "street",
  #                                zip: "4522201", lat: 0.0, lng: 0.0,
  #                                stripe_customer_token: "sdas5644as11",
  #                                stripe_card_last_digits: "1",
  #                                stripe_card_brand: "sbi", status: 1)}

  #   it 'is valid with valid attributes' do
  #     subject.photo = @file
  #     expect(subject).to be_valid
  #   end

  #   it 'is not valid without photo' do
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without about' do
  #     subject.about = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without business' do
  #     subject.business = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without keywords' do
  #     subject.keywords = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without balance' do
  #     subject.balance = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without state' do
  #     subject.state = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without city' do
  #     subject.city = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without street' do
  #     subject.street = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without lat' do
  #     subject.lat = nil
  #     expect(subject).to_not be_valid
  #   end

  #   it 'is not valid without lng' do
  #     subject.lng = nil
  #     expect(subject).to_not be_valid
  #   end
  # end
end
