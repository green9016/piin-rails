# frozen_string_literal: true

require 'net/http'
require 'net/smtp'

HTTP_ERRORS = [
    EOFError,
    Errno::ECONNRESET,
    Errno::EINVAL,
    Net::HTTPBadResponse,
    Net::HTTPHeaderSyntaxError,
    Net::ProtocolError,
    Timeout::Error
].freeze

SMTP_SERVER_ERRORS = [
    IOError,
    Net::SMTPAuthenticationError,
    Net::SMTPServerBusy,
    Net::SMTPUnknownError,
    Timeout::Error
].freeze

SMTP_CLIENT_ERRORS = [
    Net::SMTPFatalError,
    Net::SMTPSyntaxError
].freeze

SMTP_ERRORS = SMTP_SERVER_ERRORS + SMTP_CLIENT_ERRORS