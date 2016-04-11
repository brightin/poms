require 'spec_helper'

module Poms
  module Api
    module URIs
      describe Media do
        it 'returns the correct uri for a single resource' do
          uri = described_class.single('the-mid')
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid')
        end

        it 'returns the correct uri for multiple resources' do
          uri = described_class.multiple
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/multiple')
        end

        it 'returns the correct uri for descendants' do
          uri = described_class.descendants('the-mid')
          expect(uri.to_s).to eql('https://rs.poms.omroep.nl/v1/api/media/the-mid/descendants')
        end
      end
    end
  end
end
