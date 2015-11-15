# == Class: straycat::os::user
#
# User and user environment setup
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
# Tom McLaughlin <tom@jana.com>
#
# === Copyright
#
# Copyright 2015 Jana Mobile, Inc.
#
class straycat::os::user {

  # The resources are chained to ensure they're added in the same order.
  # FIXME: We should generate MOTD from a template but OS images creation
  # doesn't leave image or kickstart info elsewhere.
  file_line { 'motd_fqdn':
    path => '/etc/motd',
    line => " Hostname:\t\t${::fqdn}"
  } ->
  file_line { 'motd_straycat_dc':
    path  => '/etc/motd',
    match => "Straycat DC.*",
    line  => " Straycat DC:\t\t${::straycat_dc}"
  } ->
  file_line { 'motd_straycat_env':
    path  => '/etc/motd',
    match => "Straycat Environment.*",
    line  => " Straycat Environment:\t${::straycat_env}"
  } ->
  file_line { 'motd_straycat_svc':
    path  => '/etc/motd',
    match => "Straycat Service.*",
    line  => " Straycat Service:\t${::straycat_svc}"
  }

}
