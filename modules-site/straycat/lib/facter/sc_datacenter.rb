# === Fact: sc_datacenter
#
# Name of datacenter host resides in.
#
require 'facter'

Facter.add('sc_datacenter') do
  setcode do
    if Facter.value('domain') == 'straycat.local'
      'local'
    else
      'northend'
    end
  end
end