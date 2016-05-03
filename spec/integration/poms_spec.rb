require 'spec_helper'
require 'poms'

RSpec.describe Poms do
  before do
    described_class.configure
  end

  describe '.first' do
    subject { described_class.first('POMS_S_NTR_2448585') }

    it 'returns a hash of the found object' do
      expect(subject).to be_a(Hash)
    end

    it 'finds the right hash' do
      expect(subject['mid']).to eq('POMS_S_NTR_2448585')
    end

    it 'returns nil if not found' do
      expect(described_class.first('ABCD')).to be_nil
    end
  end

  describe '.first!' do
    subject { described_class.first!('POMS_S_NTR_2448585') }

    it 'returns a hash of the found object' do
      expect(subject).to be_a(Hash)
    end

    it 'finds the right hash' do
      expect(subject['mid']).to eq('POMS_S_NTR_2448585')
    end

    it 'returns nil if not found' do
      expect { described_class.first!('ABCD') }
        .to raise_error { Poms::Errors::HttpMissingError }
    end
  end

  describe '.fetch' do
    subject { described_class.fetch(['VPWON_1251179']) }

    it 'returns a hash with the results' do
      expect(subject).to be_a(Hash)
      expect(subject).to include('items')
    end

    it 'finds the right hash' do
      expect(subject['items'].first['result']['mid']).to eq('VPWON_1251179')
    end
  end

  describe '.members' do
    subject { described_class.members('POMS_S_NTR_2448585') }

    it 'returns an enumerable of hashes' do
      expect(subject).to all(be_a(Hash))
    end

    it 'finds the right members' do
      expect(subject.first['mid']).to eq('WO_NTR_3665130')
    end
  end

  describe '.merged_series' do
    let(:url) do
      Poms::Api::URIs::Media.redirects(
        Addressable::URI.parse('https://rs.poms.omroep.nl'))
    end

    it 'turns the json into a hash' do
      mids = described_class.merged_series
      expect(mids.keys).to include('POMS_S_EO_097367')
      expect(mids.values).to include('VPWON_1257896')
    end

    it 'throws an error on a network error' do
      stub_request(:any, url).to_return(body: '{}', status: 500)
      expect { described_class.merged_series }
        .to raise_error(Poms::Errors::HttpServerError)
    end

    it 'throws an error on invalid json' do
      stub_request(:any, url).to_return(body: 'Test')
      expect { described_class.merged_series }.to raise_error(JSON::ParserError)
    end

    it 'throws an error on timeout' do
      stub_request(:any, url).to_timeout
      expect { described_class.merged_series }.to raise_error(Poms::Errors::HttpError)
    end
  end

  describe '.fetch_current_broadcast' do
    before do
      # VCR currently matches on URI and this URI changes depending on the time
      allow(described_class::Api::URIs::Schedule)
        .to receive(:default_channel_params)
        .and_return(
          max: 1,
          sort: 'desc',
          start: Time.new(2016, 5, 1, 16, 0, 0).iso8601,
          stop: Time.new(2016, 5, 2, 16, 0, 0).iso8601
        )
    end

    subject { described_class.fetch_current_broadcast('OPVO') }

    it 'only returns a result for the current channel' do
      expect(subject['channel']).to eq('OPVO')
    end

    it 'only returns broadcasts' do
      expect(subject['media']['type']).to eq('BROADCAST')
    end

    it 'has a mid' do
      expect(subject['media']['mid']).not_to be_nil
    end
  end
end
