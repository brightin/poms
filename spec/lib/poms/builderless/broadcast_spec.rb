require 'spec_helper'
require 'poms/builderless/broadcast'

describe.skip Poms::Builderless::Broadcast do
  let(:subject) { Poms.fetch_current_broadcast('OPVO') }

  describe '#starts_at' do
    it 'returns a datetime' do
      expect(subject.schedule_events.first.starts_at).to be_a DateTime
    end
  end
end
