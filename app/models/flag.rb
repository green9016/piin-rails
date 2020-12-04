# frozen_string_literal: true

class Flag < ApplicationRecord
  include Discard::Model

  belongs_to :feature
  belongs_to :firm

  validates :feature_id, uniqueness: { scope: :firm_id }
end
