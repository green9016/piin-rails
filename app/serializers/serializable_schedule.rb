# frozen_string_literal: true

class SerializableSchedule < JSONAPI::Serializable::Resource
  type 'schedules'

  attributes :week_days

  attribute :starts do
    @object.starts.strftime('%H:%M')
  end

  attribute :ends do
    @object.ends.strftime('%H:%M')
  end

  meta do
    {}
  end
end
