require 'spec_helper'

RSpec.describe Poms::Api::Auth do
  describe '.encode' do
    it 'encodes the message with the secret' do
      expect(described_class.encode('secret', 'message'))
        .to eq("i19IcCmVwVmMVz2x4hhmqbgl1KeU0WnXBgoDYFeWNgs=")
    end
  end

  describe '.message' do
    it 'creates a message' do
      message = described_class.message(
        Addressable::URI.parse('/v1/api/media/redirects/'),
        'http://zapp.nl',
        Date.parse('2015-01-01').rfc822)
      expect(message).to eq(
        'origin:http://zapp.nl,x-npo-date:Thu, 1 Jan 2015 00:00:00 '\
        '+0000,uri:/v1/api/media/redirects/')
    end

    it 'sorts the params' do
      message = described_class.message(
        Addressable::URI.parse('/v1/api/media/redirects/?b=1&a=2'),
        'http://zapp.nl',
        Date.parse('2015-01-01').rfc822)
      expect(message).to eq(
        'origin:http://zapp.nl,x-npo-date:Thu, 1 Jan 2015 00:00:00 '\
        '+0000,uri:/v1/api/media/redirects/,a:2,b:1')
    end
  end
end
