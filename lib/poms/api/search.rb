module Poms
  module Api
    module Search
      def self.build(options)
        all = options.map do |key, value|
          case key
          when :start_time
            { 'searches' => { 'sortDates' => { 'begin' => ms(value) } } }
          when :end_time
            { 'searches' => { 'sortDates' => { 'end' => ms(value) } } }
          when :type
            { 'facets' => { 'subsearch' => { 'types' => value } } }
          end
        end
        all.reduce(&:deep_merge)
      end

      private

      def self.ms(time)
        time.to_i * 1000
      end
    end
  end
end
