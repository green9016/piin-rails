# frozen_string_literal: true

class Schedule < ApplicationRecord
  include Discard::Model
  include HasWeekDays

  belongs_to :scheduleable, polymorphic: true

  validates :starts, :ends, presence: true
end
