# frozen_string_literal: true

module AdminSerializers
  class SerializableUser < JSONAPI::Serializable::Resource
    type 'users'

    attributes :username, :email, :first_name, :last_name, :birthday, :status,
               :created_at, :photo, :phone, :last_sign_in_at, :photo, :blocked

    has_many :reports
    has_many :posts
    has_many :support_tickets, polymorphic: true

    meta do
      { reports_count: @object&.reports&.count,
        liked_posts_count: @object&.likes&.count,
        favorites_count: @object&.visited_locations&.count }
    end
  end
end
