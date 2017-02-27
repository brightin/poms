require 'poms/api/client'

module Poms
  module Api
    # The JsonClient module is a wrapper around the regular Client module. It
    # requests and responses to handle JSON-formatted bodies.
    module JsonClient
      DEFAULT_HEADERS = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }.freeze

      module_function

      def get(uri, credentials, headers = {})
        response = Client.execute(
          Request.new(
            method: :get,
            uri: uri,
            headers: DEFAULT_HEADERS.merge(headers),
            credentials: credentials
          )
        )
        JSON.parse(response.body)
      end

      def post(uri, body, credentials, headers = {})
        response = Client.execute(
          Request.new(
            method: :post,
            uri: uri,
            body: body.to_json,
            headers: DEFAULT_HEADERS.merge(headers),
            credentials: credentials
          )
        )
        JSON.parse(response.body)
      end
    end
  end
end
