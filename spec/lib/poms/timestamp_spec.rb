require 'spec_helper'
require 'poms/timestamp'

describe Poms::Timestamp do
  describe '#to_datetime' do
    it 'converts Poms timestamps to DateTime' do
      expect(described_class.to_datetime(1_453_217_700_000))
        .to eq(Time.parse('2016-01-19 16:35:00 +0100'))
    end

    it 'returns nil if the argument is falsey' do
      expect(described_class.to_datetime(nil)).to be_nil
    end
  end

  describe '#to_unix_ms' do
    it 'converts a DateTime object to unix timestamp in milliseconds' do
      datetime = Time.new(2016, 1, 19, 16, 35, 0, '+01:00')
      expect(described_class.to_unix_ms(datetime)).to eq(1_453_217_700_000)
    end
  end
end
