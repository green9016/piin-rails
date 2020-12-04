# frozen_string_literal: true

class SerializableStat < JSONAPI::Serializable::Resource
  type 'stats'

  attributes :stats_count, :stats_revenue, :stats_transaction
end
