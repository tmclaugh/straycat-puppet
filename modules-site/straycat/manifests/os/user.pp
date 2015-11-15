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

  file { '/etc/motd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('straycat/os/user/motd')
  }

  # Set some facts as referenceable shell vars
  # /etc/default is a more potable location than /etc/sysconfig
  file { '/etc/default/straycat':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('straycat/os/user/straycat')
  }

}
