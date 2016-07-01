require 'poms/timestamp'

module Poms
  # This module contains functions to extract things from a Poms hash that may
  # be harder to access, or are accessed in multiple places.
  module Fields
    module_function

    # Returns the title, main by default
    def title(item, type = 'MAIN')
      value_of_type(item, 'titles', type)
    end

    # Returns the description, main by default
    def description(item, type = 'MAIN')
      value_of_type(item, 'descriptions', type)
    end

    # Returns the images from the hash
    def images(item)
      item['images']
    end

    # Extracts the image id from an image hash
    # Expects a hash of just an image from POMS
    def image_id(image)
      return unless image['imageUri']
      image['imageUri'].split(':').last
    end

    # Returns the id of the first image of nil if there are none.
    def first_image_id(item)
      return unless images(item)
      image_id(images(item).first)
    end

    def mid(item)
      item['mid']
    end

    # Returns the revision from a Poms hash.
    def rev(item)
      item['_rev'].to_i
    end

    # Returns the revision from a Poms hash.
    def last_modified(item)
      item.fetch('lastModified', nil)
    end

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

    # Returns the enddate of the publication of an internet vod if present.
    def available_until(item)
      return if item['predictions'].blank?
      internetvod = item['predictions']
                    .find { |p| p['platform'] == 'INTERNETVOD' }
      return unless internetvod
      Timestamp.to_datetime(internetvod['publishStop'])
    end

    # Returns the position in the parent context if it is present.
    def position(item)
      parent = item['memberOf']
      parent.first['index'] if parent.present?
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

    # Turns the event into a hash.
    def hash_event(event)
      {
        'starts_at' => Timestamp.to_datetime(event.fetch('start')),
        'ends_at' => Timestamp.to_datetime(event.fetch('start') +
          event.fetch('duration'))
      }
    end
    private_class_method :hash_event

    # Poms has arrays of hashes for some types that have a value and type. This
    # is a way to access those simply.
    #
    # Example:
    #    item = {'titles' => [{'value' => 'Main title', 'type' => 'MAIN'},
    #           {'value' => 'Subtitle', 'type' => 'SUB'}] }
    #    value_of_type(item, 'titles', 'MAIN') => 'Main title'
    #
    # @param item The Poms hash
    # @param key The key of the array we want to look in
    # @param type The type to select
    def value_of_type(item, key, type)
      return unless item[key]
      res = item[key].find { |value| value['type'] == type }
      return unless res
      res['value']
    end
    private_class_method :value_of_type
  end
end
