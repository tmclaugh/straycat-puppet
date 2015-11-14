# == Class: straycat::os::setup
#
# OS setup
#
# These resources should be realized before we start establishing service or
# role resources.
#
# === Parameters
#
# [*parameter*]
#   Descripotion.
#   Type: bool
#
# === Examples
#
# class { '::class::name' }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
#
class straycat::os::setup (
  $ipa_setup,
  $puppet_setup
) {

  include concat::setup

  anchor { 'straycat::os::setup::start': }

  $real_ipa_setup = pick($::sc_ipa_setup, $ipa_setup)
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

  anchor { 'straycat::os::setup::end': }


  Anchor['straycat::os::setup::start'] ->
  Class['::straycat::os::resolv'] ->
  Class['::straycat::os::pkgrepos'] ->
  Class['::straycat::os::time'] ->
  Anchor['straycat::os::setup::end']

}
