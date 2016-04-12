# Builds required authorization headers
module Poms
  module Api
    # This module creates the authentication headers for the Poms API.
    # see: http://wiki.publiekeomroep.nl/display/npoapi/Algemeen

    class Authorization
      attr_reader :uri, :credentials

      # @param uri An instance of an Addressable::URI of the requested uri
      # @param credentials Provided through Poms.configure
      def initialize(uri:, credentials:)
        @uri = uri
        @credentials = credentials
      end

      # Authorize a request by setting the headers
      def authorize(request)
        headers.each { |key, value| request[key] = value }
        request
      end

      private

      def headers
        {
          'Origin' => credentials.origin,
          'X-NPO-Date' => datetime,
          'Authorization' => "NPO #{credentials.key}:#{encoded_message}",
          'Content-Type' => 'application/json'
        }
      end

      def datetime
        @datetime ||= Time.now.rfc822
      end

      def message
        [
          "origin:#{credentials.origin}",
          "x-npo-date:#{datetime}",
          "uri:#{uri.path}",
          query_params
        ].compact.join(',')
      end

      # Encodes the message according to POMS documentation
      def encoded_message
        digest = OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha256'),
          credentials.secret,
          message
        )
        Base64.encode64(digest).strip
      end

      # The url params as a Ruby hash
      def query_params
        params = uri.query_values
        return unless params
        params.map { |key, value| "#{key}:#{value}" }.sort.join(',')
      end
    end
  end
end
