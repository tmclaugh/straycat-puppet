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
# === Globals
#
# [*sc_ipa_setup*]
#   Override $ipa_setup.  Useful for testing FreeIPA with Vagrant.
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

  $real_ipa_setup = pick($::sc_ipa_setup, $ipa_setup)

  include stdlib
  include concat::setup

  anchor { 'straycat::os::start': }

  class { '::straycat::os::resolv': }

  # repositories
  class { '::straycat::os::pkgrepos': }

  class { '::straycat::os::time': }

  class { '::straycat::os::puppet': }

  if $real_ipa_setup {
    class { '::straycat::os::ipa_client':
      require => Class['::straycat::os::time']
    }
    contain '::straycat::os::ipa_client'
  }

  anchor { 'straycat::os::end': }


  Anchor['straycat::os::start'] ->
  Class['::straycat::os::resolv'] ->
  Class['::straycat::os::pkgrepos'] ->
  Class['::straycat::os::time'] ->
  Class['::straycat::os::puppet'] ->
  Anchor['straycat::os::end']

}
