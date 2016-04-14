require 'active_support/all'
require 'addressable/uri'
require 'base64'
require 'json'
require 'net/https'
require 'timeout'

require 'poms/api/auth'
require 'poms/api/media'
require 'poms/api/request'
require 'poms/api/search'
require 'poms/api/uris'
require 'poms/builderless/broadcast'
require 'poms/builderless/clip'
require 'poms/errors/authentication_error'
require 'poms/fields'
require 'poms/merged_series'
require 'poms/timestamp'

# Main interface for the POMS gem
#
# Strategy
# 1 -- Build a request object that can be executed (PostRequest || GetRequest object)
# 2 -- Execute the request. Retry on failures (max 10?)
# 3 -- Parse responded JSON. Extract fields if necessary
module Poms
  extend self
  attr_reader :config

  def configure
    @config ||= OpenStruct.new
    yield @config
  end

  def fetch(arg)
    assert_credentials
    request = Api::Media.multiple(Array(arg), config)
    JSON.parse(request.execute.body)
  end

  def descendants(mid, search_params)
    assert_credentials
    request = Api::Media.descendants(mid, config, search_params)
    JSON.parse(request.execute.body)
  end

  private

  def assert_credentials
    raise Errors::AuthenticationError, 'API key not supplied'    if config.key.blank?
    raise Errors::AuthenticationError, 'API secret not supplied' if config.secret.blank?
    raise Errors::AuthenticationError, 'Origin not supplied'     if config.origin.blank?
  end
end
