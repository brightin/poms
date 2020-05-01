require 'spec_helper'
require 'poms/fields/schedule'

module Poms
  module Fields
    describe Schedule do
      let(:poms_data) do
        JSON.parse File.read('spec/fixtures/poms_broadcast.json')
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

      describe '.publication' do
        it 'returns the first publication for PUBLISHED INTERNETVOD' do
          expect(described_class.publication(poms_data))
            .to include(
              'platform' => 'INTERNETVOD',
              'workflow' => 'PUBLISHED'
            )
        end

        it 'does not return publication with owner NEBO' do
          expect(described_class.publication(poms_data)['owner'])
            .not_to eq('NEBO')
        end
      end

      describe '.publish_start' do
        it 'returns the proper publish start date of a publication' do
          expect(described_class.publish_start(poms_data))
            .to eq('Tue, 28 May 2013 18:29:49 +0200')
        end
      end

      describe '.publish_stop' do
        it 'returns the proper publish stop date of a publication' do
          expect(described_class.publish_stop(poms_data))
            .to eq('Fri, 29 Jul 2016 04:16:30 +0200')
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
end
