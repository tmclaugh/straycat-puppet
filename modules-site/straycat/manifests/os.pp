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
# [*puppet_setup*]
#    If the puppet agent should not be setup here.  Useful when puppet
#    cannot be contained in tghis class without creating a circular
#    dependency.  In those cases another class has to realize this class.
#    ex. puppetmasters.
#    Type: bool
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
  $ipa_setup    = true,
  $puppet_setup = true
) {

  $real_ipa_setup = pick($::sc_ipa_setup, $ipa_setup)

  include stdlib
  include concat::setup

  anchor { 'straycat::os::start': }

  class { '::straycat::os::resolv': }

  # repositories
  class { '::straycat::os::pkgrepos': }

  class { '::straycat::os::time': }

  if $puppet_setup {
    class { '::straycat::os::puppet':
      require => Class['::straycat::os::time']
    }
    contain '::straycat::os::puppet'
  }

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
  Anchor['straycat::os::end']

}
