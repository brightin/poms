require 'net/https'
require 'poms/api/response'
require 'poms/errors'

module Poms
  module Api
    module Drivers
      # The NetHttp driver is a special module that can be used to implement the
      # HTTP operations in the Client module. This is done by including a driver
      # module into the client.
      #
      # This module isolates all knowledge of Net::HTTP.
      #
      # @see Poms::Api::Client
      module NetHttp
        NET_HTTP_ERRORS = [
          Timeout::Error,
          Errno::EINVAL,
          Errno::ECONNRESET,
          EOFError,
          Net::HTTPBadResponse,
          Net::HTTPHeaderSyntaxError,
          Net::ProtocolError
        ].freeze

        module_function

        def execute(request_description)
          response = attempt_request(
            request_description.uri,
            prepare_request(request_description)
          )
          Response.new(response.code, response.body, response.to_hash)
        end

        def attempt_request(uri, request)
          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            http.open_timeout = 5
            http.read_timeout = 5
            http.request(request)
          end
        rescue *NET_HTTP_ERRORS => e
          raise Errors::HttpError,
            "An error (#{e.class}) occured while processing your request."
        end

        def prepare_request(request_description)
          request = request_to_net_http_request(request_description)
          request.body = request_description.body.to_s
          request_description.headers.each do |key, value|
            request[key] = value
          end
          request
        end

        def request_to_net_http_request(request_description)
          uri = request_description.uri
          if request_description.get?
            Net::HTTP::Get.new(uri)
          elsif request_description.post?
            Net::HTTP::Post.new(uri)
          else
            raise ArgumentError, 'can only execute GET or POST requests'
          end
        end

        private_class_method :attempt_request, :prepare_request,
          :request_to_net_http_request
      end
    end
  end
end
