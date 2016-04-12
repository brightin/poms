# Builds required authorization headers
module Poms
  module Api
    # This module creates the authentication headers for the Poms API.
    # see: http://wiki.publiekeomroep.nl/display/npoapi/Algemeen

    class Authorization
      attr_reader :uri, :credentials

      # Encodes the message according to POMS documentation
      # @param secret The Poms API secret key
      # @param message The message that needs to be hashed.
      def self.encode(secret:, message:)
        sha256_encoding = OpenSSL::Digest.new('sha256')
        digest = OpenSSL::HMAC.digest(sha256_encoding, secret, message)
        Base64.encode64(digest).strip
      end

      # @param uri An instance of an Addressable::URI of the requested uri
      # @param credentials Provided through Poms.configure
      def initialize(uri:, credentials:)
        @uri = uri
        @credentials = credentials
      end

      def headers
        {
          'Origin' => credentials.origin,
          'X-NPO-Date' => datetime,
          'Authorization' => "NPO #{credentials.key}:#{encoded_message}",
          'Content-Type' => 'application/json'
        }
      end

      private

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

      def encoded_message
        binding.pry
        self.class.encode(secret: credentials.secret, message: message)
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
