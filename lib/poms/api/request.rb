# Create a new request for the Poms API. The request is initialized with a
# URI to be called and the key, secret and origin that are needed for
# authentication.

# @param uri An instance of an Addressable::URI of the requested uri
# @param credentials A struct containing the poms api key, secret and origin
# @param body The data that is submitted in the post request body
module Poms
  module Api
    # Contains authentication and request specific properties
    module RequestExecution
      def execute_ssl_request(host, request)
        Net::HTTP.start(host, 443, use_ssl: true) do |http|
          http.open_timeout = 30
          http.read_timeout = 30
          http.request(request)
        end
      end

      def headers
        date = Time.now.rfc822
        message = Auth.message(uri, credentials.origin, date)
        encoded_message = Auth.encode(credentials.secret, message)
        {
          'Origin' => credentials.origin,
          'X-NPO-Date' => date,
          'Authorization' => "NPO #{credentials.key}:#{encoded_message}",
          'Content-Type' => 'application/json'
        }
      end
    end

    # Build an executable PostRequest
    class PostRequest
      include RequestExecution
      attr_reader :uri, :credentials, :body

      def initialize(uri, credentials, body: {})
        @uri = uri
        @credentials = credentials
        @body = body
      end

      # Executes a POST request with post body
      def execute
        req = Net::HTTP::Post.new(uri.path)
        req.body = body.to_json
        headers.each { |key, val| req[key] = val }
        execute_ssl_request(uri.host, req)
      end
    end

    # Build an executable GetRequest
    class GetRequest
      include RequestExecution
      attr_reader :uri, :credentials

      def initialize(uri, credentials)
        @uri = uri
        @credentials = credentials
      end

      # Executes a GET request
      def execute
        req = Net::HTTP::Get.new(uri.path)
        headers.each { |key, val| req[key] = val }
        execute_ssl_request(uri.host, req)
      end
    end
  end
end
