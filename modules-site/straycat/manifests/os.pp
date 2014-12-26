# == Class: straycat::os
#
# Basic OS setup
#
# === Parameters
#
# [*ipa_setup*]
#   If IPA client should be setup.  Useful for bypassing setup on IPA
#   masters and replicas.
#   Type: bool
#
# === Examples
#
#   class { '::straycay::os': }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os (
  $ipa_setup = true
) {

  include stdlib

  $ntp_hosts = hiera('straycat::infra::time')

  class { '::straycat::os::resolv': }

  # repositories
  class { '::straycat::os::pkgrepos::epel': }

  class { '::ntp':
    servers        => $ntp_hosts,
    service_enable => true,
    service_ensure => running,
    service_manage => true
  }

  if $ipa_setup {
    class { '::straycat::os::ipa_client':
      require => Class['::ntp']
    }
    contain '::straycat::os::ipa_client'
  }
}
