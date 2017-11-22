require 'poms/errors'

module Poms
  # The configuration is a container for configuration values that control the
  # Poms gem.
  class Configuration
    attr_accessor :key, :origin, :secret, :base_uri
    attr_reader :credentials

    # The fallback base URI in case none is explicitly specified.
    DEFAULT_BASE_URI = 'https://rs.poms.omroep.nl'.freeze

    # List of special credential keys that need to be present in order to be
    # able to use the API.
    REQUIRED_CREDENTIAL_KEYS = %i[key origin secret].freeze

    # Build a new configuration object, including validations and freezing.
    #
    # You probably want to use a block to specify the different configuration
    # options, but when no block is specified, default values will be read from
    # the environment.
    def initialize
      reset
      yield self if block_given?
      validate
      @credentials = OpenStruct.new(key: key, origin: origin, secret: secret)
      freeze
    end

    private

    def validate
      assert_credentials
      assert_base_uri
    end

    def assert_credentials
      REQUIRED_CREDENTIAL_KEYS.each do |key|
        next if send(key).present?
        raise Errors::AuthenticationError, "#{key} must be supplied"
      end
    end

    def assert_base_uri
      base_uri or
        raise Errors::MissingConfigurationError, 'base_uri must be supplied'
    end

    def reset
      @credentials = nil
      self.key = ENV['POMS_KEY']
      self.origin = ENV['POMS_ORIGIN']
      self.secret = ENV['POMS_SECRET']
      self.base_uri = Addressable::URI.parse(
        ENV.fetch('POMS_BASE_URI', DEFAULT_BASE_URI)
      )
    end
  end
end
