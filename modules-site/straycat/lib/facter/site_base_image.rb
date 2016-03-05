# === Fact: site_base_image
#
# Return the name of the system image.  This is consistent across AWS,
# Vagrant, etc. while using AMI ID in AWS would not be.
#
require 'facter'

Facter.add('site_base_image') do
  setcode do
    File.open('/etc/site-base-image').read.strip
  end
end