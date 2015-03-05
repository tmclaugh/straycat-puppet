# === Fact: jm_dc
#
# Name of datacenter host resides in.
#
require 'facter'

Facter.add('jm_dc') do
  setcode do
    if Facter.value('domain') == 'jana.local'
      'local'
    elsif Facter.value('domain') == 'jana-net.lan'
      'home'
    elsif Facter.value('domain') =~ /.*\.jana-net.com$/
      Facter.value('domain').split('.')[0]
    end
  end
end