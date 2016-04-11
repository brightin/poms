module Poms
  module Errors
    class AuthenticationError < StandardError
      attr_accessor :message

      def initialize(message)
        @message = message
      end
    end
  end
end

