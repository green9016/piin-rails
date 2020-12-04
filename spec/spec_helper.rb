# frozen_string_literal: true

if ENV['CODACY_PROJECT_TOKEN']
  require 'codacy-coverage'
  Codacy::Reporter.start
end

require 'webmock/rspec'
require 'rspec/json_expectations'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
