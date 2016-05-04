require 'active_support/all'
require 'poms/api/uris'
require 'poms/api/json_client'
require 'poms/api/pagination_client'
require 'poms/errors'
require 'poms/api/search'
require 'poms/configuration'
require 'json'

# Main interface for the POMS gem
#
# Strategy
# 1 -- Build a request object that can be executed (PostRequest || GetRequest object)
# 2 -- Execute the request. Retry on failures (max 10?)
# 3 -- Parse responded JSON. Extract fields if necessary
module Poms
  extend self

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
    Api::JsonClient.get(
      Api::Uris::Media.single(config.base_uri, mid),
      config.credentials
    )
  end

  def fetch(arg)
    Api::JsonClient.post(
      Api::Uris::Media.multiple(config.base_uri),
      Array(arg),
      config.credentials
    )
  end

  def descendants(mid, search_params = {})
    Api::PaginationClient.post(
      Api::Uris::Media.descendants(config.base_uri, mid),
      Api::Search.build(search_params),
      config.credentials
    )
  end

  def members(mid)
    Api::PaginationClient.get(
      Api::Uris::Media.members(config.base_uri, mid),
      config.credentials
    )
  end

  # Gets the merged serie mids as a hash. Expects a JSON response from
  # the server with a `map` key.
  #
  # @return [Hash] a hash with old_mid => new_mid pairs
  def merged_series
    Api::JsonClient.get(
      Api::Uris::Media.redirects(config.base_uri),
      config
    ).fetch('map')
  end

  # Fetches a single current broadcast for the provided channel
  #
  # @param channel The channel name
  def currently_scheduled_event(channel)
    Poms::Api::JsonClient.get(
      Poms::Api::Uris::Schedule.channel(config.base_uri, channel),
      config.credentials
    ).fetch('items').first
  end

  def reset_config
    @config = nil
  end

  private

  def config
    @config or raise Errors::NotConfigured
  end
end
