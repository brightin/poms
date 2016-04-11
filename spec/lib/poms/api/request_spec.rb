require 'spec_helper'
require 'pry'

describe 'Poms Api Requests' do
  let(:test_url) { 'https://rs.poms.omroep.nl/v1/api/media' }

  describe Poms::Api::GetRequest do
    subject do
      uri = Addressable::URI.parse(test_url)
      credentials = OpenStruct.new(key: 'key', secret: 'secret', origin: 'http://zapp.nl')
      described_class.new(uri, credentials)
    end

    it 'makes the request' do
      stub = stub_request(:get, test_url)
      subject.execute
      expect(stub).to have_been_requested
    end

    it 'sets the headers' do
      allow(Poms::Api::Auth).to receive(:encode).and_return('encoded-string')
      stub = stub_request(:get, test_url).with(
        headers: {
          'Origin' => 'http://zapp.nl',
          'X-NPO-Date' => Time.now.rfc822,
          'Authorization' => 'NPO key:encoded-string'
        }
      )
      subject.execute
      expect(stub).to have_been_requested
    end
  end

  describe Poms::Api::PostRequest do
    subject do
      uri = Addressable::URI.parse(test_url)
      credentials = OpenStruct.new(key: 'key', secret: 'secret', origin: 'http://zapp.nl')
      described_class.new(uri, credentials, body: { foo: 'bar' })
    end

    it 'makes a post request' do
      stub = stub_request(:post, test_url)
      subject.execute
      expect(stub).to have_been_requested
    end

    it 'sets the post body' do
      stub = stub_request(:post, test_url).with(body: { foo: 'bar' }.to_json)
      subject.execute
      expect(stub).to have_been_requested
    end

    it 'sets the correct headers' do
      allow(Poms::Api::Auth).to receive(:encode).and_return('encoded-string')
      stub = stub_request(:post, test_url).with(
        headers: {
          'Origin' => 'http://zapp.nl',
          'X-NPO-Date' => Time.now.rfc822,
          'Authorization' => 'NPO key:encoded-string',
          'Content-Type' => 'application/json'
        }
      )
      subject.execute
      expect(stub).to have_been_requested
    end
  end
end
