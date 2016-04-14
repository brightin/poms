require 'spec_helper'

describe Poms::Timestamp do
  it 'converts Poms timestamps to DateTime' do
    expect(described_class.convert(1_453_217_700_000))
      .to eq(Time.parse '2016-01-19 16:35:00 +0100')
  end

  it 'returns nil if the argument is falsey' do
    expect(described_class.convert(nil))
      .to be_nil
  end
end
