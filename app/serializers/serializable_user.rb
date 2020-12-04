# frozen_string_literal: true

class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :username, :email, :first_name, :last_name, :birthday, :photo,
             :phone, :photo

  has_many :reports
end
