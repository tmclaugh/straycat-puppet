# == Class: straycat::svc::puppet::master
#
# Setup a puppetmaster
#
# === Parameters
#
# [*parameter*]
#   Description of parameter and its usage.
#
# === Examples
#
#   class { '::straycat::svc::puppet::master': }
#
# === FIXME
#
# * We're not managing the Puppetlabs repo in Puppet which we should be
#   doing.  Need to add a resource for that.
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::svc::puppet::master (
  $bootstrap                 = false,
  $enable_puppetdb           = true,
  $enable_foreman            = true,
  $foreman_url               = undef,
  $puppet_psk                = undef,
  $puppet_version            = "3.7.3-1.${::centos_pkg_release}",
  $puppetdb_terminus_version = "2.2.2-1.${::centos_pkg_release}",
  $puppetdb_host             = undef,
  $hiera_version             = "1.3.4-1.${::centos_pkg_release}",
  $hiera_eyaml_version       = '2.0.2',
  $hiera_eyaml_gpg_version   = '0.4',
  $hiera_key_name            = "puppet.${::domain}"
) {

  validate_string($puppet_psk)

  $puppet_autosign_script = '/usr/local/bin/puppet_autosign.py'
  $puppet_act_as_ca       = true
  $puppet_central_ca      = undef
  $puppet_keys_dir        = '/etc/puppet/keys'
  $puppet_master_package  = 'puppet-server'

  $hiera_key      = "${puppet_keys_dir}/${hiera_key_name}.secret.key"


  if $enable_puppetdb {
    validate_string($puppetdb_host)
    $storeconfigs_dbadapter = 'puppetdb'
    $puppetdb_report        = ['puppetdb']
    $storeconfigs           = true
  } else {
    $storeconfigs_dbadapter = undef
    $puppetdb_report        = []
    $storeconfigs           = false
  }

  if $enable_foreman {
    validate_string($foreman_url)
    $foreman_report = ['foreman']
    $external_nodes = '/etc/puppet/node.rb'

    # FIXME: This is terrible.  We need a CA setup
    # The Puppet user can't read the host's SSL key so we're going to copy it
    # and make it avaible to the Puppet user.  This is a trade off that allows
    # us to better secure Foreman.
    file { '/etc/pki/tls/private/foreman.key':
      ensure => present,
      owner  => 'root',
      group  => 'puppet',
      mode   => '0640',
      source => "file:///etc/pki/tls/private/localhost.key"
    }

    class { '::foreman::puppetmaster' :
      foreman_url => $foreman_url,
      enc         => true,
      reports     => true,
      #ssl_cert    => '/etc/pki/tls/certs/server.crt',
      ssl_key     => '/etc/pki/tls/private/foreman.key',
      ssl_ca      => '/etc/pki/tls/cert.pem',
      before      => Class['::puppet::master'], # This has to be done before SSL info is overwritten.
      require     => File['/etc/pki/tls/private/foreman.key']
    }
    contain '::foreman::puppetmaster'

  } else {
    $external_nodes = undef
    $foreman_report = []
  }

  if $bootstrap {
    $puppet_autosign = true
    $manifest        = '/etc/puppet/manifests/site.pp'

    file { '/etc/puppet/manifests/site.pp':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('straycat/svc/puppet/bootstrap-site.pp'),
      require => Package[$puppet_master_package],
      before  => Service['httpd']
    }
  } else {
    $puppet_autosign = $puppet_autosign_script
    $manifest        = '$confdir/environments/$environment/manifests/site.pp'
  }

  contain ::straycat::svc::passenger

  # Hiera related
  ensure_resource('package', 'ruby-devel')
  ensure_resource('package', 'gnupg2')

  package { 'hiera-eyaml':
    ensure   => $hiera_eyaml_version,
    provider => gem,
    require  => Package['ruby-devel'],
    notify   => Class['::puppet::master'] # Make sure puppet service sees bumped version.
  }

  package { 'hiera-eyaml-gpg':
    ensure   => $hiera_eyaml_gpg_version,
    provider => gem,
    require  => [Package['gnupg2'], Package['ruby-devel']],
    notify   => Class['::puppet::master'] # Make sure puppet service sees bumped version.
  }

  # FIXME: hiera is depndency of puppet so this will install the latest
  # version of puppet.
  package { 'hiera':
    ensure => $hiera_version,
    notify => Class['::puppet::master']
  }

  file { $puppet_keys_dir:
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0600',
    recurse => true
  }

  #exec { 'Import Hiera keyring':
  #  command => "/usr/bin/gpg --homedir ${puppet_keys_dir} --import ${hiera_key}",
  #  unless  => "/usr/bin/gpg --homedir ${puppet_keys_dir} --list-secret-keys | /bin/egrep -q '^uid\\s*${hiera_key_name}'",
  #  require => File[$puppet_keys_dir],
  #  notify  => Exec['Setting Hiera keyring owner/perms']
  #}

  # We manage $puppet_keys_dir as a recursive directory but we need to have
  # the directory exist before importing keys.  That means files created
  # after importing keys don't have permissions managed until the second
  # Puppet run.  Below is a quick hack.
  #exec { 'Setting Hiera keyring owner/perms':
  #  command     => "/bin/chown puppet:puppet ${puppet_keys_dir}/*; /bin/chmod 0600 ${puppet_keys_dir}/*",
  #  refreshonly => true
  #}

  #exec { "No Puppet Hiera keyring present. Retrieve key from https://ss.hubspotcentral.net/SecretView.aspx?secretid=${hiera_gpg_ss_id}":
  #  unless  => "/usr/bin/test -f ${puppet_keys_dir}/secring.gpg",
  #  command => '/bin/false',
  #  require => Exec['Import Hiera keyring']
  #}


  # PSK setup
  file { '/etc/puppet/puppet_psk':
    ensure  => present,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0440',
    content => template('straycat/svc/puppet/puppet_psk')
  }

  file { $puppet_autosign_script:
    ensure  => present,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0555',
    content => template('straycat/svc/puppet/puppet_autosign.py')
  }

  # FIXME: This is here for Vagrant only.  Need to fix this later.
  exec { 'puppet-delete-temp-certs':
    command => 'find /var/lib/puppet/ssl -type f -delete',
    creates => '/var/lib/puppet/ssl/ca/inventory.txt',
    path    => ['/usr/bin'],
  }

  exec { 'puppet-create-ca':
    command => 'puppet master --onetime',
    path    => ['/usr/bin'],
    creates => '/var/lib/puppet/ssl/ca/inventory.txt',
    returns => [0, 1],
    require => Exec['puppet-delete-temp-certs']
  }

  class { '::puppet::master':
    version                   => $puppet_version,
    puppet_passenger          => true,
    puppet_passenger_port     => '8140',
    package_provider          => 'yum',
    puppet_master_package     => $puppet_master_package,
    manage_vardir             => false,
    modulepath                => '$confdir/environments/$environment/modules:$confdir/environments/$environment/modules-site',
    manifest                  => $manifest,
    proxy_allow_from          => [ 'all' ],
    reports                   => concat($puppetdb_report, $foreman_report),
    storeconfigs              => $storeconfigs,
    storeconfigs_dbadapter    => $storeconfigs_dbadapter,
    storeconfigs_dbserver     => $puppetdb_host,
    puppetdb_terminus_version => $puppetdb_terminus_version,  # puppetdb-terminus package version.
    autosign                  => $puppet_autosign,
    puppet_extra_configs      => {
      master        => {
        ca              => $puppet_act_as_ca,
        node_terminus   => 'exec',
        external_nodes  => $external_nodes,
        dns_alt_names   => "puppet.${::domain}",
        hiera_config    => '$confdir/environments/$environment/hiera.yaml',
      },
    },
    require                   => [File['/etc/puppet/puppet_psk'],
                                  File['/usr/local/bin/puppet_autosign.py'],
                                  Exec['puppet-create-ca']]
  }
  contain '::puppet::master'


  class { '::straycat::svc::puppet::r10k': }
  contain '::straycat::svc::puppet::r10k'

}
