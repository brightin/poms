require 'poms'

# You can build a search params hash using Poms::Api::Search
query = Poms::Api::Search.build(start_time: Time.now, end_time: 2.weeks.from_now)

# And use it to query the poms API
Poms.descendants('VPWON_1251179', query)
# => Returns all media that is a descendant of the media by the given mid, and
# was broadcasted between now and next week

# This example will fetch all media that is of type "BROADCAST"
query = Poms::Api::Search.build(start_time: Time.now, type: 'BROADCAST')

# Use it
Poms.descendants('VPWON_1251179', query)
# => Returns all media that is a descendant of the media by the given mid, has
# not aired yet and is a broadcast
