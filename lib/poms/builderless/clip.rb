module Poms
  module Builderless
    # A single clip fetched from Poms
    class Clip
      def initialize(hash)
        @hash = hash
      end

      def title
        Fields.title(@hash)
      end

      def mid
        @hash['mid']
      end

      def video_url
        return unless @hash['locations']
        @hash['locations'].first['programUrl']
      end

      def position
        return unless @hash['memberOf']
        @hash['memberOf'].first['index']
      end

      def image_id
        images = Fields.images(@hash)
        return unless images
        Fields.image_id(images.first)
      end
    end
  end
end
