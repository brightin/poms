require 'spec_helper'

describe.skip Poms do
  describe '#fetch_current_broadcast' do
    let(:current_broadcast) { Poms.fetch_current_broadcast('NED3') }

    it 'has a title' do
      expect(current_broadcast.title).to be_present
    end

    it 'has a mid' do
      expect(current_broadcast.mid).to be_present
    end

    it 'has scheduled events with last with starts_at' do
      expect(current_broadcast.schedule_events.last.starts_at).to be_present
    end
  end

  describe '#fetch_current_broadcast_and_key' do
    let(:current_broadcast) { Poms.fetch_current_broadcast_and_key('NED3') }

    it 'has a key' do
      expect(current_broadcast[:key]).to be_present
    end

    it 'has a broadcast with a mid' do
      expect(current_broadcast[:broadcast].mid).to be_present
    end
  end

  describe '#fetch an aankeiler' do
    let(:result) { Poms.fetch('WO_NPO_698651') }

    it 'has images' do
      expect(result.images.first.image_uri).to be_present
    end
  end

  describe '#fetch a broadcast' do
    let(:result) { Poms.fetch('POW_00182680') }

    it 'has scheduled events with last with starts_at' do
      expect(result.schedule_events.last.starts_at).to be_present
    end
  end

  describe '#fetch a clip' do
    let(:clip) { Poms.fetch('POMS_EO_622912') }

    it 'has a title' do
      expect(clip['titles']).to be_present
    end
  end

  describe '#fetch_group' do
    let(:clip) { Poms.fetch_group('POMS_S_NPO_823012')['rows'].first['doc'] }

    it 'has a child with a title' do
      expect(clip['titles']).to be_present
    end

    it 'has a child with a media type' do
      expect(clip['avType']).to be_present
    end

    it 'has a child with a media type' do
      expect(clip['mid']).to be_present
    end
  end

  describe '#upcoming_broadcasts'

  describe '#fetch_descendant_mids' do
    let(:result) { Poms.fetch_descendant_mids('POMS_S_KRO_059861') }
    it 'returns a list of mids' do
      expect(result.first).to eq('KN_1655665')
    end
  end

  describe '#fetch_descendants_for_serie' do
    let(:result) { Poms.fetch_descendants_for_serie('POMS_S_KRO_059861') }
    it 'builds a list of broadcasts' do
      expect(result.first.mid).to eq('KN_1655665')
    end
  end
end
