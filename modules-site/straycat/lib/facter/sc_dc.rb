# === Fact: sc_dc
#
# Name of datacenter host resides in.
#
require 'facter'

Facter.add('sc_dc') do
  setcode do
    if Facter.value('domain') == 'straycat.local'
      'local'
    else
      'northend'
    end
  end
end