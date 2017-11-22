require 'spec_helper'
require 'poms/api/pagination_client'
require 'poms/api/uris'
require 'poms/api/search'
require 'poms/configuration'

module Poms
  module Api
    RSpec.describe PaginationClient do
      let(:config) { Configuration.new }

      it 'returns all members of get in one Array' do
        result = described_class.execute(Request.new(
          uri: Api::Uris::Media.members(config.base_uri, 'POMS_S_NTR_2448585'),
          credentials: config.credentials
        ))
        expect(result.count).to eq(16)
      end

      it 'returns all members of post in one Array' do
        search_params = { starts_at: Time.new(2014, 12, 1) }
        result = described_class.execute(Request.new(
          method: :post,
          uri: Api::Uris::Media.members(config.base_uri, 'POMS_S_NTR_2448585'),
          body: Api::Search.build(search_params),
          credentials: config.credentials
        ))
        expect(result.count).to eq(11)
      end
    end
  end
end
