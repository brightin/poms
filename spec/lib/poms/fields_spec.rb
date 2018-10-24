require 'spec_helper'
require 'poms/fields'

module Poms
  describe Fields do
    let(:poms_data) do
      JSON.parse File.read('spec/fixtures/poms_broadcast.json')
    end

    describe '.title' do
      it 'returns the first MAIN title' do
        expect(described_class.title(poms_data)).to eq('VRijland')
      end

      it 'returns nil if no title can be found' do
        expect(described_class.title(poms_data, 'NONEXISTANTTYPE')).to be_nil
      end

      it 'returns nil if there is no title' do
        expect(described_class.title({})).to be_nil
      end

      it 'does not throw an error when item is nil' do
        expect { described_class.title(nil) }.not_to raise_error
      end
    end

    describe '.descendants_of' do
      it 'returns all descendantOfs with type SERIES' do
        expect(described_class.descendants_of(poms_data, 'SERIES')).to eq(
          [{
            'midRef' => 'POMS_S_KRO_059857',
            'type' => 'SERIES',
            'urnRef' => 'urn:vpro:media:group:5346131'
          }]
        )
      end
    end

    describe '.description' do
      it 'returns the first MAIN description' do
        expect(described_class.description(poms_data)).to eq("Li biedt Barry \
een baantje aan bij de uitdragerij en vraagt zich meteen af of dat wel zo slim \
was. Timon en Joep zien de criminele organisatie de Rijland Angels. Timon wil \
naar hun loods, maar is dat wel een goed idee?")
      end

      it 'returns nil if no description can be found' do
        expect(described_class.description(poms_data, 'NONEXISTANTTYPE'))
          .to be_nil
      end

      it 'returns nil if there is no description' do
        expect(described_class.description({})).to be_nil
      end
    end

    describe '.images' do
      it 'returns an array of 4 items' do
        expect(described_class.images(poms_data).count).to eq 4
      end

      it 'orders the items by type' do
        types = described_class.images(poms_data).map { |i| i['type'] }
        expect(types).to eq(%w[PICTURE STILL STILL STILL])
      end
    end

    describe '.image_order_index' do
      it 'returns 0 when PROMO_LANDSCAPE' do
        expect(described_class.image_order_index('type' => 'PROMO_LANDSCAPE'))
          .to eq 0
      end

      it 'returns 1 when PICTURE' do
        expect(described_class.image_order_index('type' => 'PICTURE')).to eq 1
      end

      it 'returns 2 for everything else' do
        expect(described_class.image_order_index('type' => 'STILL')).to eq 2
        expect(described_class.image_order_index('type' => 'BOGUS')).to eq 2
      end
    end

    describe '.image_id' do
      it 'returns the id of the image' do
        expect(described_class.image_id(poms_data['images'].first))
          .to eq('184169')
      end

      it 'returns nil if there is no image' do
        expect(described_class.image_id({})).to be_nil
      end
    end

    describe '.first_image_id' do
      it 'returns the id of the first image' do
        expect(described_class.first_image_id(poms_data)).to eq('184169')
      end

      it 'returns nil if there is no image' do
        expect(described_class.first_image_id({})).to be_nil
      end
    end

    describe '.mid' do
      it 'returns the mid' do
        expect(described_class.mid(poms_data)).to eq('KRO_1614405')
      end

      it 'returns nil if it cannot be found' do
        expect(described_class.mid({})).to be_nil
      end
    end

    describe '.odi_streams' do
      it 'returns an array of stream types' do
        expect(described_class.odi_streams(poms_data)).to match_array(
          %w[adaptive h264_sb h264_bb h264_std wvc1_std wmv_sb wmv_bb]
        )
      end

      it 'returns an empty array of no stream types are found' do
        expect(described_class.odi_streams({})).to eq([])
      end
    end

    describe '.available_until' do
      it 'returns the enddate of the INTERNETVOD prediction' do
        expect(described_class.available_until(poms_data))
          .to eq('Sat, 27 Jun 2015 07:12:48 +0200')
      end

      it 'returns nil if the INTERNETVOD has no publishStop' do
        expect(
          described_class.available_until(
            'predictions' => [
              { 'state' => 'REALIZED', 'platform' => 'INTERNETVOD' }
            ]
          )
        ).to be_nil
      end
    end

    describe '.position' do
      let(:clip) { JSON.parse(File.read('spec/fixtures/poms_clip.json')) }

      context 'with no extra arguments' do
        it "returns the clip's index for his first parent" do
          expect(described_class.position(clip)).to eq(31)
        end
      end

      context 'with no parents' do
        it 'returns nil' do
          expect(described_class.position('memberOf' => [])).to be_nil
          expect(described_class.position({})).to be_nil
        end
      end

      context 'when given an ancestor midRef' do
        it "returns the clip's index in that parent" do
          pos = described_class.position(clip, member_of: 'POMS_S_ZAPP_4110813')
          expect(pos).to be(1)
        end

        it 'returns nil if no matching parent found' do
          expect(described_class.position(clip, member_of: 'nobody')).to be_nil
        end
      end
    end

    describe '.broadcasters' do
      it 'returns the provided broadcasters as an Array' do
        expect(described_class.broadcasters(poms_data))
          .to eql(['KRO', 'NPO Zapp'])
      end
    end

    describe '.age_rating' do
      it 'returns the age rating' do
        expect(described_class.age_rating('ageRating' => '6')).to eql('6')
        expect(described_class.age_rating('ageRating' => 'ALL')).to eql('ALL')
      end

      it 'returns ALL if no age rating is present' do
        expect(described_class.age_rating({})).to eql('ALL')
      end
    end

    describe '.content_ratings' do
      it 'returns an array with the content ratings' do
        poms_data = { 'contentRatings' => %w[ANGST GEWELD] }
        expect(described_class.content_ratings(poms_data))
          .to eql(%w[ANGST GEWELD])
      end

      it 'returns an empty array if no content rating is present' do
        expect(described_class.content_ratings({})).to eql([])
      end
    end

    describe '.schedule_events' do
      it 'returns an empty array if there are no scheduled events' do
        expect(described_class.schedule_events({})).to eq([])
      end

      it 'raises keyerror when the events do not have the right keys' do
        expect {
          described_class.schedule_events(
            'scheduleEvents' => [{ 'start' => 10 }]
          )
        }.to raise_error(KeyError)
      end

      it 'returns a collection of objects with a start and end time' do
        expect(described_class.schedule_events(poms_data)).to match_array(
          [
            {
              'starts_at' => Timestamp.to_datetime(1_369_757_335_000),
              'ends_at' => Timestamp.to_datetime(1_369_758_384_000)
            },
            {
              'starts_at' => Timestamp.to_datetime(1_464_792_900_000),
              'ends_at' => Timestamp.to_datetime(1_464_794_169_000)
            }
          ]
        )
      end

      it 'accepts a block with events' do
        result = described_class.schedule_events(poms_data) do |events|
          events.reject { |e| e['channel'] == 'BVNT' }
        end
        expect(result).not_to include(
          'starts_at' => Timestamp.to_datetime(1_464_792_900_000),
          'ends_at' => Timestamp.to_datetime(1_464_794_169_000)
        )
      end
    end
  end
end
