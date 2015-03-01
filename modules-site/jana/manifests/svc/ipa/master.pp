# == Class: jana::svc::ipa::master
#
# Setup a FreeIPA master host
#
# === Parameters
#
# [*ipa_master_conf*]
#   Hash of configuration values.
#   Type: hash
#
# === Examples
#
#   class { '::jana::svc::ipa::master':
#     ipa_master_conf => { ... }
#   }
#
# === BUGS
#
# * Get away from $ipa_master_conf and get configuration from Hiera.
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::svc::ipa::master (
  $ipa_domain      = undef,
  $ipa_realm       = undef,
  $ipa_adminpw     = undef,
  $ipa_dspw        = undef,
  $ipa_forwarders  = [],
) {

  # FIXME: Need to add dependency ordering.
  package { 'bind':
    ensure => installed
  }
  package { 'bind-dyndb-ldap':
    ensure  => installed,
    require => Package['bind']
  }

  class { '::ipa':
    master     => true,
    domain     => $ipa_domain,
    realm      => $ipa_realm,
    adminpw    => $ipa_adminpw,
    dspw       => $ipa_dspw,
    dns        => true,
    forwarders => $ipa_forwarders
  }

}
