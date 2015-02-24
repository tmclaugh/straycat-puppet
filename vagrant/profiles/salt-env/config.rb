# Example for provisioning multiple hosts.
Vagrant.configure('2') do |config|
  # primary: designates this will be the default host when no hostname is
  # given to commands.
  config.vm.define "master", primary: true do |node|
    node.vm.hostname = 'salt-master.straycat.local'
    node.vm.network "private_network", type: "dhcp"

    node.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'straycat::roles::salt::master'}
    end

  end

  config.vm.define "minion-1" do |node|
    node.vm.hostname = 'salt-minion-1.straycat.local'
    node.vm.network "private_network", type: "dhcp"
    node.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'straycat::roles::salt::minion'}
    end
  end

  config.vm.define "minion-2" do |node|
    node.vm.hostname = 'salt-minion-2.straycat.local'
    node.vm.network "private_network", type: "dhcp"
    node.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'straycat::roles::salt::minion'}
    end
  end
end
