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
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
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
  # /etc/default is a more portable location than /etc/sysconfig
  file { '/etc/default/site':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('straycat/os/user/default_site')
  }

  file { '/etc/profile.d/site_prompt.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('straycat/os/user/site_prompt.sh'),
    require => File['/etc/default/site']
  }
}
