# puppet version should match what is configured
# in cloud config within the .box image at
#

$master_conf_dir   = $vg_puppetmaster_dir
$master_local_dir  = $vg_puppetmaster_local
$puppetmaster_conf = "${master_conf_dir}/puppet-vagrant.conf"
$fileserver_conf   = "${master_conf_dir}/fileserver.conf"

$real_puppet_ver          = $puppet_ver
$real_hiera_ver           = $hiera_ver
$real_hiera_eyaml_ver     = $hiera_eyaml_ver
$real_hiera_eyaml_gpg_ver = $hiera_eyaml_gpg_ver
#$highline_ver             = '1.6.21'  # Newest version does not work on CentOS
                                      # 6 with older ruby.

$systemd_file = '/usr/lib/systemd/system/puppetmaster.service'

if $centos_major == '7' {
  $sysconfig_home_string = 'HOME=/root'

  # FIXME: Should be fixed in a later package release.
  exec {'Fix PUPPETMASTER_EXTRA_OPTS':
    command => "/usr/bin/sed -i 's/\${\\(.*\\)}/\$\\1/' ${systemd_file}",
    onlyif  => "/usr/bin/egrep '\\$\\{.*\\}' ${systemd_file}",
    require => Package['puppetmaster'],
    before  => Service['puppetmaster'],
    notify  => Exec['systemctl reload']
  }

  exec {'systemctl reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true
  }
} else {
  $sysconfig_home_string = 'export HOME=/root'
}

File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

# Hiera keys need to be in /etc/puppet because that's where hiera.yaml says
# they should be.
file { '/etc/puppet/keys':
  ensure  => directory,
  mode    => '0600',
  recurse => true
}

file { '/etc/puppet/keys/localhost.gpg':
  ensure  => present,
  mode    => '0600',
  source  => "file:///${master_local_dir}/vagrant/files/localhost.gpg",
  require => File['/etc/puppet/keys']
}

# This needs to be done before the puppetmaster service starts.
exec { 'hiera_gpg_key':
  command => '/usr/bin/gpg --homedir /etc/puppet/keys --import /etc/puppet/keys/localhost.gpg',
  returns => [0, 2],
  require => File['/etc/puppet/keys/localhost.gpg']
}

package { 'ruby-dev':
  ensure => present
}

package { 'libncurses5-dev':
  ensure => present
}

package { 'hiera':
  ensure => $real_hiera_ver,
}

package { 'highline':
  ensure   => $highline_ver,
  provider => gem
}

package { 'hiera-eyaml':
  ensure   => $real_hiera_eyaml_ver,
  provider => gem,
  require  => [ Package['hiera'],
                Package['ruby-dev'],
                Package['libncurses5-dev'],
                Package['highline'] ]
}

package { 'hiera-eyaml-gpg':
  ensure   => $real_hiera_eyaml_gpg_ver,
  provider => gem,
  require  => [Package['hiera'], Package['hiera-eyaml'], Exec[hiera_gpg_key]]
}

package { 'puppetmaster':
  ensure  => $real_puppet_ver,
  require => Package['hiera'],
  notify  => Exec['delete_original_ssl_certs']
}

exec { 'delete_original_ssl_certs' :
  command     => '/usr/bin/find /var/lib/puppet/ssl/ -type f -delete',
  refreshonly => true
}

# NOTE: HOME needs to be defined or hiera-eyaml-gpg will fail.
file { '/etc/default/puppetmaster':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => "START=yes\n${sysconfig_home_string}\nDAEMON_OPTS='--config ${puppetmaster_conf} --logdest /var/log/puppetmaster.log'\nPORT=8140\n",
  require => [Package['puppetmaster'], Exec['delete_original_ssl_certs']],
  notify  => Service['puppetmaster']
}

file { $puppetmaster_conf:
  ensure  => present,
  content => "
[main]
    server                    = localhost
    confdir                   = ${master_conf_dir}
    logdir                    = ${master_conf_dir}/log
    vardir                    = ${master_conf_dir}/var
    ssldir                    = ${master_conf_dir}/ssl
    templatedir               = ${master_conf_dir}/templates
    factpath                  = \$vardir/lib/facter
    pluginsync                = true

[agent]
    environment               = production

[master]
    modulepath                = ${master_local_dir}/modules:${master_local_dir}/modules-site
    manifestdir               = ${master_conf_dir}/manifests
    hiera_config              = ${master_local_dir}/hiera.yaml
    environment               = production
    autosign                  = true
    ssl_client_header         = SSL_CLIENT_S_DN
    ssl_client_verify_header  = SSL_CLIENT_VERIFY
    certname                  = localhost
    report                    = true
    reports                   = store
    dns_alt_names             = ${::fqdn}
    user                      = root
",
  require => Package['puppetmaster'],
  before  => Service['puppetmaster'],
}

file { $fileserver_conf:
  ensure  => present,
  content => "#Serve out CA to all.
[ca]
  path ${master_conf_dir}/ssl/ca
  allow *
",
  require => Package['puppetmaster'],
  before  => Service['puppetmaster'],
}

file { [$master_conf_dir,
        "${master_conf_dir}/manifests" ]:
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755'
}

file { "${master_conf_dir}/autosign.conf":
  ensure  => present,
  content => '*',
  require => Package['puppetmaster'],
  before  => Service['puppetmaster'],
}


# FIXME: Maybe we should create a *.<domain>.local node in the real site.pp
# to handle Vagrant hosts.
file { "${master_conf_dir}/manifests/site.pp":
  ensure  => present,
  content => template('site.pp.erb'),
  before  => Service['puppetmaster'],
}

# The next two resources handle hieradata without altering hiera.yaml.
file { '/etc/puppet/environments':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
  before => Service['puppetmaster']
}

file  { '/etc/puppet/environments/production':
  ensure  => link,
  target  => '/etc/puppet-local',
  require => File['/etc/puppet/environments'],
  before  => Service['puppetmaster']
}

file {'/var/lib/puppet/concat':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755'
}

service { 'puppetmaster':
  ensure  => running,
  require => [Package['puppetmaster'],
              Package['hiera'],
              Package['hiera-eyaml'],
              Package['hiera-eyaml-gpg']],
  notify  => Exec['puppetmaster wait']
}

# systemd appears to be reporting the service has started before the service
# has fully finished starting and causing
# File["${master_conf_dir}/var/concat"] to fail.  hack this with a sleep
# resource to give us time until we have a better idea.
exec {'puppetmaster wait':
  command     => '/bin/sleep 5',
  refreshonly => true,
}

file {"${master_conf_dir}/var/concat":
  ensure  => link,
  target  => '/var/lib/puppet/concat',
  require => Exec['puppetmaster wait']
}
