# === Fact: straycat_dc
#
# Name of datacenter host resides in.
#
require 'facter'

Facter.add('straycat_dc') do
  setcode do
    if Facter.value('domain') == 'straycat.dev'
      'local'
    elsif Facter.value('ec2_placement_availability_zone') 
      acter.value('ec2_placement_availability_zone')[0..-2]
    elsif Facter.value('domain') == 'straycat-net.lan'
      'home'
    end
  end
end