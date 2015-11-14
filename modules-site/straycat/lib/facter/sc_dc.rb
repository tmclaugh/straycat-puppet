# === Fact: sc_dc
#
# Name of datacenter host resides in.
#
require 'facter'

Facter.add('sc_dc') do
  setcode do
    if Facter.value('domain') == 'straycat.dev'
      'local'
    elsif Facter.value('domain') == 'straycat-net.lan'
      'home'
    elsif Facter.value('domain') =~ /.*\.straycat-net.dhs.org$/
      Facter.value('domain').split('.')[0]
    end
  end
end