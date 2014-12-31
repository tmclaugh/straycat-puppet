Vagrant.configure('2') do |config|

  config.hostmanager.manage_host = true

  config.vm.define "ipa" do |ipa|
    ipa.vm.hostname = 'ipa-master.straycat.local'
    ipa.vm.network :private_network, ip: "192.168.4.10"

    ipa.vm.provision :puppet_server, id: 'default_puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'straycat::roles::dc::master'}
    end
  end

  config.vm.define "base" do |base|
    base.vm.hostname = 'base.straycat.local'
    base.vm.network :private_network, ip: "192.168.4.11"

    base.vm.provision :puppet_server, id: 'default_puppet_server' do |puppet|
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'straycat::roles::base',
                               'sc_ipa_setup' => true }
    end
  end
end