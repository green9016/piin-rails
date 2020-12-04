# frozen_string_literal: true

class Post < ApplicationRecord
  include Discard::Model
  include HasActive
  include HasChecked

  belongs_to :firm
  belongs_to :business

  has_many :offers, -> {merge(Offer.kept)}, inverse_of: :post, dependent: :destroy
  has_many :views, -> { merge(View.kept) }, inverse_of: :post, class_name: 'View', dependent: :destroy
  has_many :reports, -> { merge(Report.kept) }, inverse_of: :post, dependent: :destroy
  has_many :like_dislikes, -> { merge(LikeDislike.kept) }, inverse_of: :post, dependent: :destroy
  has_many :users, through: :like_dislikes
  has_many :pins, through: :firm

  validates :photo, presence: true, if: proc { |p|
    p.description.blank? || p.color_code.blank?
  }
  validates :description, :color_code, presence: true, if: proc { |p|
    p.photo.blank?
  }
  validates :title, :kinds, :status, presence: true
  validates :offers, length: { minimum: 1, maximum: 4 }
  validates :description, length: { maximum: 100, allow_blank: true }

  accepts_nested_attributes_for :offers, allow_destroy: true

  # TODO, this will be used?
  # before_destroy -> { can_be_erase? }

  # TODO, why we use base64?
  mount_base64_uploader :photo, PhotoUploader

  def likes
    like_dislikes.like
  end

  def dislikes
    like_dislikes.dislike
  end

  def total_likes
    likes.count
  end

  def total_dislikes
    dislikes.count
  end

  # TODO, what is this?
  ransacker :status, formatter: proc { |v| statuses[v] } do |parent|
    parent.table[:status]
  end

  def discard_post
    discard
    offers.each(&:discard)
    views.each(&:discard)
    reports.each(&:discard)
    like_dislikes.each(&:discard)
    true
  end
end
