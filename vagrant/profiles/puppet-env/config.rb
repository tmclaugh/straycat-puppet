Vagrant.configure('2') do |config|

  config.hostmanager.manage_host = $hosmanager_manage_host

  config.vm.define "bootstrap", primary: true do |pm|
    pm.vm.hostname = 'bootstrap.straycat.dev'
    pm.hostmanager.aliases = 'bootstrap'
    pm.vm.network :private_network, type: "dhcp"

    pm.vm.provision 'default_puppet', type: 'puppet' do |puppet|
      puppet.manifest_file  = "puppetmaster.pp"
      puppet.manifests_path = PUPPET_MANIFEST_PATH
      puppet.options        = "--templatedir #{VG_PUPPETMASTER_LOCAL}/vagrant/templates"
      puppet.facter = {
        "sc_environment"         => "qa",
        "environment"            => "production",
        "data_center"            => "local",
        "sc_puppetmaster_server" => "localhost",
        "os"                     => "centos6",
        "provider"               => "virtualbox",
        "security_group"         => "default",
        "vg_puppetmaster_dir"    => $vg_puppetmaster_dir,
        "vg_puppetmaster_local"  => VG_PUPPETMASTER_LOCAL,
        "default_role"           => $vg_role,
        "creator"                => USER,
        "description"            => "Testing Puppet",
        "puppet_ver"             => $puppet_ver,
        "hiera_ver"              => $hiera_ver,
        "hiera_eyaml_ver"        => $hiera_eyaml_ver,
        "hiera_eyaml_gpg_ver"    => $hiera_eyaml_gpg_ver,
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

  config.vm.define "pgsql" do |pgsql|
    pgsql.vm.hostname = 'pgsql.straycat.dev'
    pgsql.hostmanager.aliases = 'pgsql'
    pgsql.vm.network :private_network, type: "dhcp"

    pgsql.vm.provision 'default_puppet', type: 'puppet' do |p|
      p.manifests_path = PUPPET_MANIFEST_PATH
      p.manifest_file  = "noop.pp"
    end

    pgsql.vm.provision 'default_puppet_server', type: 'puppet_server' do |p|
      p.puppet_server = "bootstrap.straycat.dev"
      p.options       = "--verbose --waitforcert 1"
      p.facter        = { 'role' => 'straycat::roles::postgresql' }
    end
  end

  config.vm.define "foreman" do |foreman|
    foreman.vm.hostname = 'foreman.straycat.dev'
    foreman.hostmanager.aliases = 'foreman'
    foreman.vm.network :private_network, type: "dhcp"

    foreman.vm.provision 'default_puppet', type: 'puppet' do |p|
      p.manifests_path = PUPPET_MANIFEST_PATH
      p.manifest_file  = "noop.pp"
    end

    foreman.vm.provision 'default_puppet_server', type: 'puppet_server' do |p|
      p.puppet_server = "bootstrap.straycat.dev"
      p.options       = "--verbose --waitforcert 1"
      p.facter        = { 'role' => 'straycat::roles::foreman' }
    end
  end

  config.vm.define "puppetmaster" do |puppet|
    puppet.vm.hostname = 'puppetmaster.straycat.dev'
    puppet.hostmanager.aliases = 'puppetmaster'
    puppet.vm.network :private_network, type: "dhcp"

    puppet.vm.provision 'default_puppet', type: 'puppet' do |p|
      p.manifests_path = PUPPET_MANIFEST_PATH
      p.manifest_file  = "noop.pp"
    end

    puppet.vm.provision 'default_puppet_server', type: 'puppet_server' do |p|
      p.puppet_server = "bootstrap.straycat.dev"
      p.options       = "--verbose --waitforcert 1"
      p.facter        = { 'role'                => 'straycat::roles::puppetmaster',
                          'sc_foreman_server'   => 'foreman.straycat.dev',
                          'sc_puppet_ca_server' => 'puppetca.straycat.dev',
                          'sc_puppet_env'       => 'qa',
                          'sc_puppet_altnames'  => "puppetmaster.straycat.dev,#{$inst_name}" }
    end
  end
end