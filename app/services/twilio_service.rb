# frozen_string_literal: true

class TwilioService
  attr_reader :message, :to

  def initialize(to, message)
    @message = message
    @to = to
    @client = Twilio::REST::Client.new
  end

  def call
    @client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to,
      body: message
    )
  end
end
