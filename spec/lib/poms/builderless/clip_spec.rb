require 'spec_helper'

describe.skip Poms::Builderless::Clip do
  let(:clip) { Poms.fetch('WO_NPO_1950962') }

  it 'has a title' do
    expect(clip.title).to eq 'De wielen van de bus'
  end

  it 'has a video url' do
    expect(clip.video_url).to eq 'http://download.omroep.nl/npo/zappelin/DWVZ_AFL_86_De_wielen_van_de_bus.mp4'
  end

  it 'has an image id' do
    expect(clip.image_id).to eq '653515'
  end

  it 'has a position' do
    expect(clip.position).to eq 2
  end
end
