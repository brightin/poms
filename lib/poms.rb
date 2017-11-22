require 'active_support/all'
require 'poms/api/uris'
require 'poms/api/json_client'
require 'poms/api/pagination_client'
require 'poms/api/request'
require 'poms/errors'
require 'poms/api/search'
require 'poms/configuration'
require 'json'

# Main interface for the POMS gem
#
# Strategy
# 1 -- Build a request object that can be executed
#      (PostRequest || GetRequest object)
# 2 -- Execute the request. Retry on failures (max 10?)
# 3 -- Parse responded JSON. Extract fields if necessary
module Poms
  module_function

  def configure
    @config = Configuration.new do |config|
      yield config if block_given?
    end
    nil
  end

  # Returns the first result for a mid if it is not an error.
  #
  # @param [String] mid MID to find in POMS
  # @return [Hash, nil]
  def first(mid)
    first!(mid)
  rescue Errors::HttpMissingError
    nil
  end

  # Like `first`, but raises `Api::Client::HttpMissingError` when the requested
  # MID could not be found.
  #
  # @param [String] mid
  # @raise Api::Client::HttpMissingError
  def first!(mid)
    Api::JsonClient.execute(build_request(
      uri: Api::Uris::Media.single(config.base_uri, mid)
    ))
  end

  def fetch(arg)
    Api::JsonClient.execute(build_request(
      method: :post,
      uri: Api::Uris::Media.multiple(config.base_uri),
      body: Array(arg)
    ))
  end

  def descendants(mid, search_params = {})
    Api::PaginationClient.execute(build_request(
      method: :post,
      uri: Api::Uris::Media.descendants(config.base_uri, mid),
      body: Api::Search.build(search_params)
    ))
  end

  def members(mid)
    Api::PaginationClient.execute(build_request(
      method: :post,
      uri: Api::Uris::Media.members(config.base_uri, mid),
      body: Api::Search.empty
    ))
  end

  # Gets the merged serie mids as a hash. Expects a JSON response from
  # the server with a `map` key.
  #
  # @return [Hash] a hash with old_mid => new_mid pairs
  def merged_series
    Api::JsonClient.execute(build_request(
      uri: Api::Uris::Media.redirects(config.base_uri)
    )).fetch('map')
  end

  # Fetches the event for current broadcast on the given channel
  #
  # @param channel The channel name
  def scheduled_now(channel)
    Api::JsonClient.execute(build_request(
      uri: Api::Uris::Schedule.now(config.base_uri, channel)
    )).fetch('items').first
  end

  # Fetches the event for the next broadcast on a given channel
  #
  # @param channel The channel name
  def scheduled_next(channel)
    Api::JsonClient.execute(build_request(
      uri: Api::Uris::Schedule.next(config.base_uri, channel)
    )).fetch('items').first
  end

  def reset_config
    @config = nil
  end

  def config
    @config or raise Errors::NotConfigured
  end

  def build_request(attributes)
    Api::Request.new(attributes.merge(credentials: config.credentials))
  end

  private_class_method :config, :build_request
end
