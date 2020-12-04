# frozen_string_literal: true

class Admin < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :email, :username, presence: true, uniqueness: true
  validates :username, uniqueness: true, allow_nil: true, allow_blank: true
end
