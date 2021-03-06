module Poms
  # Functionality for manipulating Poms timestamps
  module Timestamp
    module_function

    # Convert unix timestamp in milliseconds to datetime
    def to_datetime(timestamp)
      return unless timestamp
      Time.at(timestamp / 1000).to_datetime
    end

    # Convert to unix timestamp in milliseconds
    def to_unix_ms(datetime)
      return unless datetime
      datetime.to_i * 1000
    end
  end
end
