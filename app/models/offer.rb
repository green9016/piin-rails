# frozen_string_literal: true

class Offer < ApplicationRecord
  include Discard::Model
  include HasActive
  include HasWeekDays

  belongs_to :post

  validates :post, :title, :status, presence: true
  validates :start_time, :end_time, presence: true
  validates :price, presence: true, if: proc { |o| o.percent.blank? }
  validates :percent, presence: true, if: proc { |o| o.price.blank? }
end
