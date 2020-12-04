# frozen_string_literal: true

require 'net/http'
class FacebookService # :nodoc:
  FB_URL = 'https://graph.facebook.com/v3.0/'
  FB_USER_FIELDS = 'id, name, first_name, last_name, email'

  def initialize(access_token)
    @access_token = access_token
  end

  def user_data
    response = Net::HTTP.get_response(request_uri)
    JSON.parse(response.body)
  rescue StandardError => e
    e.message
  end

  private

  def request_uri
    URI.parse(build_uri)
  end

  def build_uri
    "#{FB_URL}me?access_token=#{@access_token}&fields=#{FB_USER_FIELDS}"
  end
end
