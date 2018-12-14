require 'poms/fields/details'
require 'poms/fields/media'
require 'poms/fields/schedule'

module Poms
  module Fields
    extend Poms::Fields::Details
    extend Poms::Fields::Media
    extend Poms::Fields::Schedule
  end
end
