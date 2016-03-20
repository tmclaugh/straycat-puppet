Vagrant.configure('2') do |config|
  config.vm.define "puppetmaster", primary: true do |pm|
    pm.vm.hostname = 'puppet.straycat-net.dev'
    pm.hostmanager.aliases = ['puppet', 'puppet.straycat.dev']
    pm.vm.network :private_network, type: "dhcp"

    # Prevent breakage caused by updating the package during a run.
    pm.vm.provision :shell do |shell|
      shell.inline = "yum -y update $puppet_ver"
    end

    pm.vm.provision 'default_puppet', type: 'puppet' do |puppet|
      puppet.manifest_file  = "puppetmaster.pp"
      puppet.manifests_path = PUPPET_MANIFEST_PATH
      puppet.options        = "--templatedir #{VG_PUPPETMASTER_LOCAL}/vagrant/templates"
      puppet.facter = {
        "hs_puppetmaster_server" => "localhost",
        "vg_puppetmaster_dir"    => $vg_puppetmaster_dir,
        "vg_puppetmaster_local"  => VG_PUPPETMASTER_LOCAL,
        "puppet_ver"             => $puppet_ver,
        "hiera_ver"              => $hiera_ver,
        "hiera_eyaml_ver"        => $hiera_eyaml_ver,
        "hiera_eyaml_gpg_ver"    => $hiera_eyaml_gpg_ver,
        "site_env"               => 'dev',
        "site_dc"                => 'local'
      }
    end

    pm.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.puppet_server = "localhost"
      puppet.options       = "--verbose"
      puppet.facter        = { 'noop' => 'yes' }
    end

    # Normally straycat::os would disable this but we're skipping that.
    pm.vm.provision :shell do |shell|
      shell.inline = 'service iptables stop'
    end
  end

  config.vm.define "base" do |base|
    base.vm.hostname = 'base.straycat-net.dev'
    base.vm.network :private_network, type: "dhcp"

    base.vm.provision 'default_puppet', type: 'puppet' do |puppet|
      puppet.manifests_path = PUPPET_MANIFEST_PATH
      puppet.manifest_file  = "noop.pp"
    end

    base.vm.provision 'default_puppet_server', type: 'puppet_server' do |puppet|
      puppet.puppet_server = "puppet.straycat.dev"
      puppet.options       = "--verbose --waitforcert 120"
      puppet.facter        = { 'role' => 'straycat::roles::base'}
    end
  end
end