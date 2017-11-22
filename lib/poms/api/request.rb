require 'forwardable'

module Poms
  module Api
    # The `Request` object is an implementation-agnostic description of an HTTP
    # request, representing a combination of an HTTP method, URI, body and
    # headers.
    class Request
      attr_reader :method, :uri, :credentials, :body, :headers

      def initialize(
        uri:, method: :get, credentials: nil, body: nil, headers: {}
      )
        @uri = uri
        @method = method.to_sym
        @body = body || ''
        @headers = headers.to_h.freeze
        @credentials = credentials
        validate!
        freeze
      end

      def merge(new_attributes)
        self.class.new(attributes.merge(new_attributes))
      end

      def attributes
        {
          method: method,
          uri: uri,
          body: body,
          headers: headers,
          credentials: credentials
        }
      end

      def get?
        @method == :get
      end

      def post?
        @method == :post
      end

      private

      def validate!
        raise ArgumentError, 'method should be :get or :post' unless
          %i[get post].include?(@method)
      end
    end
  end
end
