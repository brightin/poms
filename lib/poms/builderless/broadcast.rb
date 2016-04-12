module Poms
  module Builderless
    # A single broadcast (episode) fetched from Poms
    class Broadcast
      def initialize(hash)
        @hash = hash
      end

      def title
        Fields.title(@hash)
      end

      def mid
        @hash['mid']
      end

      def schedule_events
        @hash['scheduleEvents'].map do |event|
          Event.new(event)
        end
      end
    end

    # A single event of a broadcast.
    class Event
      def initialize(hash)
        @hash = hash
      end

      def starts_at
        Timestamp.convert(@hash['start'])
      end
    end
  end
end
