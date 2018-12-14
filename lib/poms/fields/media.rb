module Poms
  module Fields
    # Module to retrieve media related information from poms items.
    module Media
      # robocop:disable Style/ModuleFunction
      extend self

      IMAGE_TYPE_PRIORITY = %w[PROMO_LANDSCAPE PICTURE].freeze

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
    end
  end
end
