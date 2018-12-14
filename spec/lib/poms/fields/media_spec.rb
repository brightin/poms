require 'spec_helper'
require 'poms/fields/media'

module Poms
  module Fields
    describe Media do
      let(:poms_data) do
        JSON.parse File.read('spec/fixtures/poms_broadcast.json')
      end

      describe '.images' do
        it 'returns an array of 4 items' do
          expect(described_class.images(poms_data).count).to eq 4
        end

        it 'orders the items by type' do
          types = described_class.images(poms_data).map { |i| i['type'] }
          expect(types).to eq(%w[PICTURE STILL STILL STILL])
        end
      end

      describe '.image_order_index' do
        it 'returns 0 when PROMO_LANDSCAPE' do
          expect(described_class.image_order_index('type' => 'PROMO_LANDSCAPE'))
            .to eq 0
        end

        it 'returns 1 when PICTURE' do
          expect(described_class.image_order_index('type' => 'PICTURE')).to eq 1
        end

        it 'returns 2 for everything else' do
          expect(described_class.image_order_index('type' => 'STILL')).to eq 2
          expect(described_class.image_order_index('type' => 'BOGUS')).to eq 2
        end
      end

      describe '.image_id' do
        it 'returns the id of the image' do
          expect(described_class.image_id(poms_data['images'].first))
            .to eq('184169')
        end

        it 'returns nil if there is no image' do
          expect(described_class.image_id({})).to be_nil
        end
      end

      describe '.first_image_id' do
        it 'returns the id of the first image' do
          expect(described_class.first_image_id(poms_data)).to eq('184169')
        end

        it 'returns nil if there is no image' do
          expect(described_class.first_image_id({})).to be_nil
        end
      end
    end
  end
end
