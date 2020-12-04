# frozen_string_literal: true

class Holiday < ApplicationRecord
  include Discard::Model
  include HasActive

  scope :upcoming, ->{ where('until_date >= :today', today: Time.zone.today) }
  scope :sorted, ->{ order(from_date: :asc) }

  validates :title, :from_date, :until_date, :status, presence: true
  validates :title, uniqueness: true

  max_paginates_per 10

  mount_base64_uploader :post_photo, PhotoUploader
  mount_base64_uploader :icon_photo, PhotoUploader
end
