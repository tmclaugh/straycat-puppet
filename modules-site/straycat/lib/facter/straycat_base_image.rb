# === Fact: straycat_base_image
#
# Return the name of the system image.  This is consistent across AWS,
# Vagrant, etc. while using AMI ID in AWS would not be.
#
require 'facter'

Facter.add('straycat_base_image') do
  setcode do
    File.open('/etc/straycat-base-image').read.strip
  end
end