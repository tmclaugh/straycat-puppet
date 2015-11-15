# == Class: straycat::os::puppet
#
# Setup Puppet client
#
# === Parameters
#
# [*puppet_server*]
#   Hostname of puppetmaster.
#   Type: string
#
# === Examples
#
# class { 'straycat::os::puppet': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os::puppet (
  $puppet_server = undef,
) {

  validate_string($puppet_server)

  $puppet_version = "3.7.3-1.${::centos_pkg_release}"
  $facter_version = "2.3.0-1.${::centos_pkg_release}"

  package { 'facter':
    ensure => $facter_version
  }

  if $::straycat_env == 'dev' {
    $puppet_agent_enabled = false
  } else {
    $puppet_agent_enabled = true
  }


  class { '::puppet::agent':
    puppet_server        => $puppet_server,
    package_provider     => 'yum',
    version              => $puppet_version,
    puppet_agent_enabled => $puppet_agent_enabled,
    puppet_agent_cron    => true,
    puppet_extra_configs => {
      agent => {
        waitforcert       => 30,
        usecacheonfailure => false,
        http_compression  => true
      }
    },
    require              => Package['facter']
  }
  contain '::puppet::agent'

  file { ['/etc/facter', '/etc/facter/facts.d']:
    ensure => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
