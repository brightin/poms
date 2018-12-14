require 'poms/fields/details'
require 'poms/fields/media'
require 'poms/fields/schedule'

module Poms
  # Collection module that import the various field modules to the higher
  # Poms::Fields level
  module Fields
    extend Poms::Fields::Details
    extend Poms::Fields::Media
    extend Poms::Fields::Schedule
  end
end
