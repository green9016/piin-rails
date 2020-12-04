# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Purchase, type: :model do
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:pin_id) }
  it { is_expected.to respond_to(:stripe_id) }
  it { is_expected.to respond_to(:company_name) }
  it { is_expected.to respond_to(:total) }
  it { is_expected.to respond_to(:date) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:status) }

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:pin) }
    it { is_expected.to have_one(:firm).through(:pin) }
  end
end
