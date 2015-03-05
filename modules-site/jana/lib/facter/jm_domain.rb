# === Fact: jm_domain
#
# Network domain sans DC name.
#
require 'facter'

Facter.add('jm_domain') do
  setcode do
    if Facter.value('domain') == 'jana.local'
      Facter.value('domain')
    elsif Facter.value('domain') == 'jana-net.lan'
      Facter.value('domain')
    # This is so we could handle regions in the hostname
    elsif Facter.value('domain').split('.')[1..-1].join('.') == 'jana-net.com'
      'jana-net.com'
    end
  end
end