Vagrant.configure('2') do |config|

  config.hostmanager.manage_host = $hosmanager_manage_host

  config.vm.define "ipa" do |ipa|
    ipa.vm.hostname = 'ipa-master.straycat.dev'
    ipa.vm.network :private_network, type: "dhcp"

    ipa.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'straycat::roles::dc::master'}
    end
  end

  config.vm.define "base" do |base|
    base.vm.hostname = 'base.straycat.dev'
    base.vm.network :private_network, type: "dhcp"

    base.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'straycat::roles::base',
                               'sc_ipa_setup' => true }
    end
  end
end