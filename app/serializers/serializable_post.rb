# frozen_string_literal: true

class SerializablePost < JSONAPI::Serializable::Resource
  type 'posts'

  attributes :title, :photo, :kinds, :description, :color_code

  attribute :active do
    @object.active?
  end

  attribute :liked do
    false
  end

  attribute :likes_count do
    @object.likes.count
  end

  attribute :views_count do
    @object.views.count
  end

  # TODO, distance from Firm to current_user
  attribute :distance do
    5
  end

  def percent_profile
    BusinessServices::ProfilePercentage.new(@object.business).call
  end

  belongs_to :firm
  belongs_to :business
  has_many :offers

  meta do
    { business_profile_percent: percent_profile }
  end
end
