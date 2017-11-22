require 'poms/timestamp'

module Poms
  module Api
    # Map search parameters to POMS specific format
    module Search
      TIME_PARAMS = {
        starts_at: 'begin',
        ends_at: 'end'
      }.freeze

      module_function

      # Helper function for returning and empty body.
      def empty
        {}
      end

      def build(options)
        return {} if options.empty?
        all = options.map do |key, value|
          case key
          when :starts_at, :ends_at
            time_params(key, value)
          when :type
            { 'searches' => { 'types' => value } }
          end
        end
        all.reduce(&:deep_merge)
      end

      def time_params(key, value)
        {
          'searches' => {
            'sortDates' => {
              TIME_PARAMS[key] => Timestamp.to_unix_ms(value)
            }
          }
        }
      end

      private_class_method :time_params
    end
  end
end
