# This file should be used used when a host should not setup a local
# puppetmaster.  It's here to get past the fact we cannot disable a default
# provisioner in Vagrant.
#
# Example:
# --------
# config.vm.define "client" do |client|
#   client.vm.provision :puppet, id: 'default_puppet' do |puppet|
#     puppet.manifests_path = PUPPET_MANIFEST_PATH
#     puppet.manifest_file  = "noop.pp"
#   end
# end
