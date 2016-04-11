require 'spec_helper'
require 'pry'

module Poms
  module Api
    describe Media do
      describe '.from_mid' do
        subject { described_class.from_mid('the-mid', {}) }
        it 'builds an executable get request' do
          expect(subject).to respond_to(:execute)
        end

        it 'builds a request targeting the correct endpoint' do
          expect(subject.uri.to_s).to eq('https://rs.poms.omroep.nl/v1/api/media/the-mid')
        end
      end

      describe '.multiple' do
        subject { described_class.multiple(['mid1', 'mid2'], {}) }

        it 'builds an executable request' do
          expect(subject).to respond_to(:execute)
        end

        it 'builds a request to the correct endpoint' do
          expect(subject.uri.to_s).to eq('https://rs.poms.omroep.nl/v1/api/media/multiple')
        end

        it 'will execute with the correct body' do
          expect(subject.body).to eql(['mid1', 'mid2'])
        end
      end

      describe '.descendants' do
        subject { described_class.descendants('the-mid', {}, { fake_query: true }) }

        it 'builds an executable request' do
          expect(subject).to respond_to(:execute)
        end

        it 'builds a request to the correct endpoint' do
          expect(subject.uri.to_s).to eq('https://rs.poms.omroep.nl/v1/api/media/the-mid/descendants')
        end

        it 'will execute with the correct body' do
          expect(subject.body).to eql({ fake_query: true })
        end
      end
    end
  end
end
