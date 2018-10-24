require 'poms/timestamp'

module Poms
  # This module contains functions to extract things from a Poms hash that may
  # be harder to access, or are accessed in multiple places.
  module Fields
    module_function

    IMAGE_TYPE_PRIORITY = %w[PROMO_LANDSCAPE PICTURE].freeze

    # Returns the title, main by default
    def title(item, type = 'MAIN')
      value_of_type(item, 'titles', type)
    end

    # Returns the description, main by default
    def description(item, type = 'MAIN')
      value_of_type(item, 'descriptions', type)
    end

    # Returns all the descendantOfs of the type given.
    # @param item The Poms Hash
    # @param type The type of descendantOfs we want
    def descendants_of(item, type)
      item['descendantOf'].select { |descendant| descendant['type'] == type }
    end

    def broadcasters(item)
      Array(item['broadcasters']).map do |key_value_pair|
        key_value_pair['value']
      end
    end

    # Returns the images from the hash
    def images(item)
      item['images'].try(:sort_by) do |i|
        image_order_index(i)
      end
    end

    # Extracts the image id from an image hash
    # Expects a hash of just an image from POMS
    def image_id(image)
      return unless image['imageUri']
      image['imageUri'].split(':').last
    end

    def image_order_index(image)
      IMAGE_TYPE_PRIORITY.index(image['type']) || IMAGE_TYPE_PRIORITY.size
    end

    # Returns the id of the first image or nil if there are none.
    def first_image_id(item)
      return unless images(item)
      image_id(images(item).first)
    end

    def mid(item)
      item['mid']
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

    # Returns the index at which it is in the parent. When no
    # :member_of keyword is given, it will return the first found
    # index. Else, when a parent is found with matching member_of
    # midref, it returns that index. Else returns nil.
    # @param item The Poms Hash
    # @param optional :member_of The midref of parent for which we
    # seek the index
    def position(item, member_of: nil)
      parent(item, midref: member_of).try(:[], 'index')
    end

    # Finds a parent the data is "member of". If :midref is given, it
    # will look for the parent that matches that mid and return nil if
    # not found. Without the :midref it will return the first parent.
    # @param item The Poms Hash
    # @param optional midref The midref of parent we seek.
    def parent(item, midref: nil)
      if midref
        parents(item).find { |parent| parent['midRef'] == midref }
      else
        parents(item).first
      end
    end

    # Returns the parents that the element is member of. Will always
    # return an array.
    def parents(item)
      Array(item['memberOf'])
    end

    # Returns the NICAM age rating of the item or ALL if no age rating exists
    def age_rating(item)
      item.fetch('ageRating', 'ALL')
    end

    # Returns an array containing zero or more content ratings of the item
    # Possible content ratings are:
    # ANGST, DISCRIMINATIE, DRUGS_EN_ALCOHOL, GEWELD, GROF_TAALGEBRUIK and SEKS
    def content_ratings(item)
      item.fetch('contentRatings', [])
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
      return unless item && item[key]
      res = item[key].find { |value| value['type'] == type }
      return unless res
      res['value']
    end
    private_class_method :value_of_type
  end
end
