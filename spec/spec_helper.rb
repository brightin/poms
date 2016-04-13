require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'
require 'fabrication'
require 'vcr'
require 'timecop'
require 'poms'

WebMock.disable_net_connect!

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
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

  config.before(:suite) do
    Timecop.freeze Time.utc(2015, 10, 6, 12)
  end
end
