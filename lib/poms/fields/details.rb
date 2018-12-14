require 'poms/timestamp'
module Poms
  module Fields
    # Module to find details from for ex. attributes on poms items.
    module Details
      extend self

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

      def mid(item)
        item['mid']
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
      # ANGST, DISCRIMINATIE, DRUGS_EN_ALCOHOL, GEWELD, GROF_TAALGEBRUIK and
      # SEKS
      def content_ratings(item)
        item.fetch('contentRatings', [])
      end

      # Poms has arrays of hashes for some types that have a value and type.
      # This is a way to access those simply.
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
end
