require 'poms'

Poms.configure do |config|
  config.key    = ENV["POMS_KEY"]
  config.origin = ENV["POMS_ORIGIN"]
  config.secret = ENV["POMS_SECRET"]
end
