require 'spec_helper'
require 'poms/fields'

module Poms
  RSpec.describe Fields do
    let(:poms_data) do
      JSON.parse File.read('spec/fixtures/poms_broadcast.json')
    end

    describe 'details module' do
      it 'returns the first MAIN title' do
        expect(described_class.title(poms_data)).to eq('VRijland')
      end
    end

    describe 'media module' do
      it 'returns the id of the image' do
        expect(described_class.image_id(poms_data['images'].first))
          .to eq('184169')
      end
    end

    describe 'schedule module' do
      it 'returns an array of stream types' do
        expect(described_class.odi_streams(poms_data)).to match_array(
          %w[adaptive h264_sb h264_bb h264_std wvc1_std wmv_sb wmv_bb]
        )
      end
    end
  end
end
