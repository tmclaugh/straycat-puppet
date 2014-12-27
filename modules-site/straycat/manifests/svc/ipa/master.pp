# == Class: straycat::svc::ipa::master
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
#   class { '::straycat::svc::ipa::master':
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
class straycat::svc::ipa::master (
  $ipa_master_conf = {}
) {

  # FIXME: Need to add dependency ordering.
  package { 'bind':
    ensure => installed
  }
  package { 'bind-dyndb-ldap':
    ensure  => installed,
    require => Package['bind']
  }

  ensure_resource('class', '::ipa', $ipa_master_conf)

}
