require 'poms/api/request'
require 'poms/api/uris'

module Poms
  module Api
    module Media
      def self.from_mid(mid, credentials)
        GetRequest.new(URIs::Media.single(mid), credentials)
      end

      def self.multiple(mids, credentials)
        PostRequest.new(URIs::Media.multiple, credentials, body: mids)
      end

      def self.descendants(mid, credentials, search_query)
        PostRequest.new(URIs::Media.descendants(mid), credentials, body: search_query)
      end
    end
  end
end
