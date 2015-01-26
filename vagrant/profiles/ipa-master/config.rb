# == Profile: ipa-master
#
# Create an IPA master host.
#
# ==== Client access.
#
# This profile will manipulate the /etc/hosts file on instances and the
# local host so that name resolution will work.  The master host can be
# accessed using the following URL:
#
# https://<instance_name>.straycat.local
#
Vagrant.configure('2') do |config|

  # Manage entries for instances on local host.
  config.hostmanager.manage_host = true

  config.vm.define "ipa-master", primary: true do |ipa|
    ipa.vm.network :private_network, type: "dhcp"
  end

end