require 'poms'

# Initialize poms with the correct credentials
Poms.configure do |config|
  config.key    = '**poms key**'
  config.origin = '**poms origin**'
  config.secret = '**poms secret**'
end

# Fetch an entity from POMS by mid
Poms.fetch("POMS_S_NTR_2342303")
# => A hash representing the data corresponding to the given MID

# Fetch multiple entities
Poms.fetch(["WO_TELEAC_003061", "POMS_EO_622912"])
# => An array of hashes representing data corresponding to those MID's
