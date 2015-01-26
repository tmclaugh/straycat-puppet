Vagrant.configure('2') do |config|

  config.hostmanager.manage_host = true

  config.vm.define "puppetmaster" do |puppet|
    puppet.vm.hostname = 'puppetmaster.straycat.local'
    puppet.hostmanager.aliases = 'puppetmaster'
    puppet.vm.network :private_network, type: "dhcp"

    puppet.vm.provision 'default_puppet', type: 'puppet' do |p|
      p.manifests_path = PUPPET_MANIFEST_PATH
      p.manifest_file  = "noop.pp"
    end

    puppet.vm.provision 'default_puppet_server', type: 'puppet_server' do |p|
    end

    # FIXME: Can't find git host ffrom vagrant.  Requires adding to
    # /etc/hosts manually.
    #
    # run bootstrap script.
    #config.vm.provision :shell do |shell|
    #  shell.inline = "/bin/sh /etc/puppet-local/bootstrap/bootstrap.sh"
    #end
  end

end