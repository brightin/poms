require 'base64'

module Poms
  module Api
    # This module can be used to create an authentication header for the Poms
    # API.
    #
    # see: http://wiki.publiekeomroep.nl/display/npoapi/Algemeen
    module Auth
      module_function

      # @param request The prepared request
      # @param credentials The Poms API credentials
      # @param clock Defaults to current time, but can be provided as Time
      def sign(request, clock = Time.now)
        credentials = request.credentials
        timestamp = clock.rfc822
        message = generate_message(request, timestamp)
        auth = "NPO #{credentials.key}:#{encrypt(credentials.secret, message)}"

        request.merge(headers: request.headers.merge(
          'Origin' => credentials.origin,
          'X-NPO-Date' => timestamp,
          'Authorization' => auth
        ))
      end

      # Create a message for the Authorization header. This is an encrypted
      # stringconsisting of a message that is hashed with a shared secret.
      def encrypt(secret, message)
        sha256 = OpenSSL::Digest.new('sha256')
        digest = OpenSSL::HMAC.digest(sha256, secret, message)
        Base64.encode64(digest).strip
      end

      # Creates a message in the required format as specified by POMS
      # documentation.
      # @param uri The Addressable::URI
      # @param timestamp An rfc822 formatted timestamp
      def generate_message(request, timestamp)
        [
          "origin:#{request.credentials.origin}",
          "x-npo-date:#{timestamp}",
          "uri:#{request.uri.path}",
          params_string(request.uri.query_values)
        ].compact.join(',')
      end

      # Convert a hash of parameters to the format expected by the message
      def params_string(params)
        return unless params
        params.map { |key, value| "#{key}:#{value}" }.sort.join(',')
      end

      private_class_method :generate_message, :encrypt, :params_string
    end
  end
end
