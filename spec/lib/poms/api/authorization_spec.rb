require 'spec_helper'

module Poms
  module Api
    describe Authorization do
      let(:current_time) { Time.now }
      let(:uri) {
        Addressable::URI.parse('https://rs.poms.omroep.nl/v1/api/media')
      }
      let(:credentials) {
        OpenStruct.new(key: 'key', secret: 'secret', origin: 'http://zapp.nl')
      }
      let(:request) { Net::HTTP::Get.new('/media') }

      subject { described_class.new(uri: uri, credentials: credentials) }

      describe '#authorize' do
        it 'augments the request with authorization headers' do
          allow(Time).to receive(:now).and_return(current_time)
          authorized_request = subject.authorize(request)
          expect(authorized_request).to be_a(Net::HTTP::Get)
          headers = authorized_request.each_header.to_a
          expect(headers).to include(
            ["authorization", "NPO key:LLZLOEQheG1u++EoN7xDYjN9qfF+pLsBInZNnM4FoEo="],
            ["content-type", "application/json"]
            ['origin', 'http://zapp.nl'],
            ['x-npo-date', current_time.rfc822],
          )
        end
      end
    end
  end
end
