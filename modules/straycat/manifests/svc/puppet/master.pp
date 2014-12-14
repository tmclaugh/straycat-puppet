# == Class: class_name
#
# Short description of class.
#
# === Parameters
#
# [*parameter*]
#   Description of parameter and its usage.
#
# === Examples
#
#   class { 'class_name':
#     parameter => 'value'
#   }
#
# === Authors
#
# tmclaughlin@hubspot.com
#
# === Copyright
#
# Copyright 2014 Hubspot
#
class straycat::svc::puppet::master (
  $puppet_psk                = undef,
  $puppet_version            = '3.7.3-1.el6',
  $puppetdb_terminus_version = '2.2.2-1.el6',
  $puppetdb_host             = undef,
  $hiera_version             = '1.3.4-1.el6',
  $hiera_eyaml_version       = '2.0.2',
  $hiera_eyaml_gpg_version   = '0.4',
  $hiera_key_name            = "puppet.${::domain}"
) {

  validate_string($puppet_psk)
  validate_string($puppetdb_host)

  $puppet_autosign_script = '/usr/local/bin/puppet_autosign.py'
  $puppet_act_as_ca       = true
  $puppet_central_ca      = undef
  $puppet_keys_dir        = '/etc/puppet/keys'

  $hiera_key      = "${puppet_keys_dir}/${hiera_key_name}.secret.key"

  # Passenger related.
  #
  $passenger_version = '4.0.48'
  ensure_resource('package', 'gcc-c++')


  class { '::passenger':
    package_ensure         => $passenger_version,
    passenger_version      => $passenger_version,
    package_provider       => 'gem',
    compile_passenger      => true,
    mod_passenger_location => "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}/buildout/apache2/mod_passenger.so",
    passenger_root         => "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}/",
    passenger_poolsize     => $::processorcount * 1.5,
    require                => Package['gcc-c++']
  }
  contain '::passenger'

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
  #file { '/etc/puppet/puppet_psk':
  #  ensure  => present,
  #  owner   => 'root',
  #  group   => 'puppet',
  #  mode    => '0440',
  #  content => template('straycat/puppet/puppet_psk')
  #}

  #file { '/usr/local/bin/puppet_autosign.py':
  #  ensure  => present,
  #  owner   => 'puppet',
  #  group   => 'puppet',
  #  mode    => '0555',
  #  content => template('straycat/puppet/puppet_autosign.py')
  #}

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
    puppet_master_package     => 'puppet-server',
    manage_vardir             => false,
    modulepath                => '$confdir/environments/$environment/modules',
    manifest                  => '$confdir/environments/$environment/manifests/site.pp',
    proxy_allow_from          => [ 'all' ],
    reports                   => [ 'puppetdb', 'foreman' ],
    storeconfigs              => true,
    storeconfigs_dbadapter    => 'puppetdb',
    storeconfigs_dbserver     => $puppetdb_host,
    puppetdb_terminus_version => $puppetdb_terminus_version,  # puppetdb-terminus package version.
    autosign                  => $puppet_autosign_script,
    puppet_extra_configs      => {
      master        => {
        ca              => $puppet_act_as_ca,
        node_terminus   => 'exec',
        dns_alt_names   => "puppet.${::domain}",
        hiera_config    => '$confdir/environments/$environment/hiera.yaml',
      },
    },
    require                   => Exec['puppet-create-ca']
  }
  contain '::puppet::master'

  file { '/etc/puppet/environments/production':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Class['::puppet::master']
  }

}
