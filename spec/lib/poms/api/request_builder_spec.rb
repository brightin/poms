require 'spec_helper'

module Poms
  module Api
    describe RequestBuilder do
      describe '#get' do
        subject { described_class.get(path: '/path') }

        it 'builds a HTTP Request object' do
          expect(subject).to be_a(Net::HTTP::Get)
        end
      end

      describe '#post' do
        let(:body) { { foo: 'bar' } }
        subject { described_class.post(path: 'path', body: body) }

        it 'builds a HTTP Request object' do
          expect(subject).to be_a(Net::HTTP::Post)
        end

        it 'sets the request body in JSON format' do
          expect(subject.body).to eq body.to_json
        end
      end
    end
  end
end
