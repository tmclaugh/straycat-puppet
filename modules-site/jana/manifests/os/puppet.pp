# == Class: jana::os::puppet
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
# class { 'jana::os::puppet': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::os::puppet (
  $puppet_server = undef,
) {

  validate_string($puppet_server)

  # We should move these values to Hiera.
  $puppet_version = "3.7.4-1puppetlabs1"
  $facter_version = "2.4.1-1puppetlabs1"

  package { 'facter':
    ensure => $facter_version
  }

  class { '::puppet::agent':
    puppet_server        => $puppet_server,
    version              => $puppet_version,
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

}
