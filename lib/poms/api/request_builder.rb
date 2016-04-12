# Creates a valid HTTP request object
module Poms
  module Api
    # Builds get and post request objects
    module RequestBuilder
      module_function

      def get(path:)
        Net::HTTP::Get.new(path)
      end

      def post(path:, body: {})
        Net::HTTP::Post.new(path).tap do |request|
          request.body = body.to_json
        end
      end
    end
  end
end
