# == Class: class_name
#
# Short description of class.
#
# === Parameters
#
# [*parameter*]
#   Description of parameter and its usage.
#
# === Examples
#
#   class { 'class_name':
#     parameter => 'value'
#   }
#
# === Authors
#
# tmclaughlin@hubspot.com
#
# === Copyright
#
# Copyright 2014 Hubspot
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
