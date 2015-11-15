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
  $ipa_setup    = false,
  $puppet_setup = true
) {

  # We need this in multiple spots so validate from this top class.
  # NOTE: validate_string() doesn't seem to work with facts for some reason.
  if $::straycat_dc == undef {
    fail('$::straycat_dc is undefined')
  }

  if $::straycat_env == undef {
    fail('$::straycat_env is undefined')
  }

  if $::straycat_svc == undef {
    fail('$::straycat_svc is undefined')
  }


  include stdlib

  anchor { 'straycat::os::start': }

  class { '::straycat::os::setup':
    ipa_setup    => $ipa_setup,
    puppet_setup => $puppet_setup,
    stage        => setup
  }

  anchor { 'straycat::os::end': }


  Anchor['straycat::os::start'] ->
  Anchor['straycat::os::end']

}
