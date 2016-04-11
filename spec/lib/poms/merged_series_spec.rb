require 'spec_helper'
require 'poms/merged_series'

describe.skip Poms::MergedSeries do
  let(:url) { described_class::TEST_URL }

  it 'turns the json into a hash' do
    mids = subject.serie_mids(url)
    expect(mids.keys).to include('POMS_S_EO_097367')
    expect(mids.values).to include('VPWON_1257896')
  end

  it 'throws an error on a network error' do
    stub_request(:any, url).to_return(body: '{}', status: 500)
    expect { subject.serie_mids(url) }.to raise_error(Poms::PomsError)
  end

  it 'throws an error on invalid json' do
    stub_request(:any, url).to_return(body: 'Test')
    expect { subject.serie_mids(url) }.to raise_error(Poms::PomsError)
  end

  it 'throws an error on timeout' do
    stub_request(:any, url).to_timeout
    expect { subject.serie_mids(url) }.to raise_error(Poms::PomsError)
  end
end
