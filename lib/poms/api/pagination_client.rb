require 'poms/api/json_client'
require 'poms/api/request'

module Poms
  module Api
    # Creates lazy Enumerators to handle pagination of the Poms API and performs
    # the request on demand.
    module PaginationClient
      module_function

      def execute(request)
        Enumerator.new do |yielder|
          page = Page.new(request.uri)
          loop do
            page.execute { |page_uri| client_execute(request, page_uri) }
            page.items.each { |item| yielder << item }
            raise StopIteration if page.final?
            page = page.next_page
          end
        end.lazy
      end

      def client_execute(request, page_uri)
        Api::JsonClient.execute(request.merge(uri: page_uri))
      end

      private_class_method :client_execute

      # Keep track of number of items and how many have been retrieved
      class Page
        def initialize(uri, offset = 0)
          uri.query_values = { offset: offset }
          @uri = uri
        end

        def next_page
          self.class.new(uri, next_index)
        end

        def final?
          next_index >= response['total']
        end

        def items
          response['items']
        end

        def execute
          @response = yield uri
        end

        private

        attr_reader :response, :uri

        def next_index
          response['offset'] + response['max']
        end
      end
    end
  end
end
