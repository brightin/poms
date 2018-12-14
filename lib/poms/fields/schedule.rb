require 'poms/timestamp'

module Poms
  module Fields
    module Schedule

      module_function

      # Returns an array of odi stream types.
      # Note: this code is copied from Broadcast and it is assumed it was working
      # there.
      def odi_streams(item)
        locations = item['locations']
        return [] if locations.nil? || locations.empty?
        odi_streams = locations.select { |l| l['programUrl'].match(/^odi/) }
        streams = odi_streams.map do |l|
          l['programUrl'].match(%r{^[\w+]+\:\/\/[\w\.]+\/video\/(\w+)\/\w+})[1]
        end
        streams.uniq
      end

      # Returns an array of start and end times for the  scheduled events for
      # this item. It returns an empty array if no events are found. You can pass
      # in a block to filter the events on data that is not returned, like
      # channel.
      #
      # @param item The Poms hash
      def schedule_events(item)
        events = item.fetch('scheduleEvents', [])
        events = yield(events) if block_given?
        events.map { |event| hash_event(event) }
      end

      # Returns the first publication from an items location array which has
      # INTERNETVOD and is PUBLISHED
      def publication(poms_item)
        return if poms_item['locations'].blank?
        poms_item['locations'].find do |item|
          item['platform'] == 'INTERNETVOD' && item['workflow'] == 'PUBLISHED'
        end
      end

      # Return the publishStop datetime from a publication
      def publish_stop(poms_item)
        published_item = publication(poms_item)
        return unless published_item
        Timestamp.to_datetime(published_item['publishStop'])
      end

      # Return the publishStart datetime from a publication
      def publish_start(poms_item)
        published_item = publication(poms_item)
        return unless published_item
        Timestamp.to_datetime(published_item['publishStart'])
      end

      # Returns the enddate of the publication of an internet vod if present.
      def available_until(item)
        return if item['predictions'].blank?
        internetvod = item['predictions']
          .find { |p| p['platform'] == 'INTERNETVOD' }
        return unless internetvod
        Timestamp.to_datetime(internetvod['publishStop'])
      end

      # Turns the event into a hash.
      def hash_event(event)
        {
          'starts_at' => Timestamp.to_datetime(event.fetch('start')),
          'ends_at' => Timestamp.to_datetime(event.fetch('start') +
            event.fetch('duration'))
        }
      end
      private_class_method :hash_event
    end
  end
end
