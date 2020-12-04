# frozen_string_literal: true

class SerializableAdmin < JSONAPI::Serializable::Resource
  type 'admins'

  attributes :username, :email, :token

  meta do
    {}
  end
end
