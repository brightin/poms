require 'spec_helper'
require 'poms/fields/details'

module Poms
  module Fields
    describe Details do
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

      describe '.mid' do
        it 'returns the mid' do
          expect(described_class.mid(poms_data)).to eq('KRO_1614405')
        end

        it 'returns nil if it cannot be found' do
          expect(described_class.mid({})).to be_nil
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
            pos = described_class
              .position(clip, member_of: 'POMS_S_ZAPP_4110813')
            expect(pos).to be(1)
          end

          it 'returns nil if no matching parent found' do
            expect(described_class.position(clip, member_of: 'nobody'))
              .to be_nil
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
    end
  end
end
