# frozen_string_literal: true

class SerializableOffer < JSONAPI::Serializable::Resource
  type 'offers'

  attributes :title, :price, :percent, :start_time, :end_time, :formatted_week_days, :status

  belongs_to :post

  attribute :open do
    [
      { id: 'Sun', value: @object.week_days.include?("0") },
      { id: 'Mon', value: @object.week_days.include?("1") },
      { id: 'Tue', value: @object.week_days.include?("2") },
      { id: 'Wed', value: @object.week_days.include?("3") },
      { id: 'Thu', value: @object.week_days.include?("4") },
      { id: 'Fri', value: @object.week_days.include?("5") },
      { id: 'Sat', value: @object.week_days.include?("6") },
    ]
  end

  meta do
    {}
  end
end
