require 'open-uri'
require 'timeout'

module Poms
  # Methods for working with the merged series api from NPO.
  module MergedSeries
    extend self

    API_URL = 'https://rs-test.poms.omroep.nl/v1/api/media/redirects/'.freeze

    # Gets the merged serie mids as a hash. Expects a JSON response from
    # the server with a `map` key.
    # Throws a PomsError if the call timeouts, has an HTTP error or JSON parse
    # error.
    #
    # @param api_url the API url to query
    # @return [Hash] a hash with old_mid => new_mid pairs
    def serie_mids(api_url = API_URL)
      Timeout.timeout(3) do
        data = open(api_url).read
        JSON.parse(data).fetch('map')
      end
    rescue OpenURI::HTTPError, JSON::ParserError, Timeout::Error => e
      raise Poms::PomsError, e.message
    end
  end
end
