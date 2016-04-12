require 'spec_helper'

module Poms
  module Api
    describe Authorization do

      describe '.encode' do
        it 'encodes the message with the secret' do
          expect(described_class.encode(secret: 'secret', message: 'message'))
            .to eq("i19IcCmVwVmMVz2x4hhmqbgl1KeU0WnXBgoDYFeWNgs=")
        end
      end

      describe '#headers' do
        let(:current_time) { Time.now }
        let(:uri) {
          Addressable::URI.parse('https://rs.poms.omroep.nl/v1/api/media')
        }
        let(:credentials) {
          OpenStruct.new(key: 'key', secret: 'secret', origin: 'http://zapp.nl')
        }
        subject { described_class.new(uri: uri, credentials: credentials) }

        it 'builds a HTTP Request object' do
          allow(Time).to receive(:now).and_return(current_time)
          allow(described_class).to receive(:encode).and_return('encoded-string')
          expect(subject.headers).to eq(
              'Origin' => 'http://zapp.nl',
              'X-NPO-Date' => current_time.rfc822,
              'Authorization' => 'NPO key:encoded-string',
              'Content-Type' => 'application/json'
            )
        end
      end
    end
  end
end
