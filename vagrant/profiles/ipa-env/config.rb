Vagrant.configure('2') do |config|

  config.hostmanager.manage_host = $hosmanager_manage_host

  config.vm.define "ipa" do |ipa|
    ipa.vm.hostname = 'ipa-master.jana.local'
    ipa.vm.network :private_network, type: "dhcp"

    ipa.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'jana::roles::dc::master'}
    end
  end

  config.vm.define "base" do |base|
    base.vm.hostname = 'base.jana.local'
    base.vm.network :private_network, type: "dhcp"

    base.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'jana::roles::base',
                               'jm_ipa_setup' => true }
    end
  end
end