# == Class: jana::os
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
# [*jm_ipa_setup*]
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
class jana::os (
  $ipa_setup    = true,
  $puppet_setup = true
) {

  $real_ipa_setup = pick($::jm_ipa_setup, $ipa_setup)

  include stdlib
  include concat::setup

  anchor { 'jana::os::start': }

  class { '::jana::os::resolv': }

  # repositories
  class { '::jana::os::pkgrepos': }

  class { '::jana::os::time': }

  if $puppet_setup {
    class { '::jana::os::puppet':
      require => Class['::jana::os::time']
    }
    contain '::jana::os::puppet'
  }

  if $real_ipa_setup {
    class { '::jana::os::ipa_client':
      require => Class['::jana::os::time']
    }
    contain '::jana::os::ipa_client'
  }

  anchor { 'jana::os::end': }


  Anchor['jana::os::start'] ->
  Class['::jana::os::resolv'] ->
  Class['::jana::os::pkgrepos'] ->
  Class['::jana::os::time'] ->
  Anchor['jana::os::end']

}
