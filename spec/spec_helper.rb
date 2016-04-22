require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'
require 'vcr'
require 'active_support/all'

WebMock.disable_net_connect!

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.filter_sensitive_data('<POMS_ORIGIN>') { ENV['POMS_ORIGIN'] }
  config.filter_sensitive_data('<POMS_KEY>') { ENV['POMS_KEY'] }
  config.filter_sensitive_data('<POMS_SECRET>') { ENV['POMS_SECRET'] }
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description]
             .split(/\s+/, 2).join('/')
             .underscore.gsub(%r{[^\w\/]+}, '_')
      VCR.use_cassette(name, options, &example)
    end
  end
end
