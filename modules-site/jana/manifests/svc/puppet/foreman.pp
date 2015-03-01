# == Class: jana::svc::puppet::foreman
#
# Setup Foreman.
#
# === Parameters
#
# [*foreman_db_host*]
#   Hostname of DB.
#
# [*foreman_db_username*]
#   Username to access DB.
#
# [*foreman_db_password*]
#   Password for accessing DB.
#
# === Examples
#
#   class { '::jana::svc::puppet::foreman':
#     foreman_db_host     => 'hostname',
#     foreman_db_username => 'user',
#     foreman_db_password => 'pass',
#   }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::svc::puppet::foreman (
  $foreman_admin_username = undef,
  $foreman_admin_password = undef,
  $foreman_db_host        = undef,
  $foreman_db_username    = undef,
  $foreman_db_password    = undef
) {

  validate_string($foreman_admin_username)
  validate_string($foreman_admin_password)
  validate_string($foreman_db_host)
  validate_string($foreman_db_username)
  validate_string($foreman_db_password)

  # Just give up and use Foreman's setup.
  #contain ::jana::svc::passenger

  $foreman_repo    = 'releases/1.7'
  $foreman_version = '1.7.1-1.el6'

  $foreman_db_type     = 'postgresql'
  $foreman_db_port     = '5432'
  $foreman_db_database = 'foreman'

  # Managing the repo on our own
  #
  # FIXME: Class[passenger] has float issues but anchoring broke other
  # resource ordering.  Good times.
  class { '::jana::os::pkgrepos::foreman':
    stage   => setup,
    require => Class['::jana::os::pkgrepos']
  }

  class { '::jana::os::pkgrepos::scl':
    stage => setup,
    require => Class['::jana::os::pkgrepos']
  }

  # FIXME: Does not support standalone ESXi yet.
  # http://projects.theforeman.org/issues/8528
  # http://projects.theforeman.org/issues/1945
  #package { 'foreman-vmware':
  #  ensure => present
  #}

  # FIXME: package is currently broken
  #package { 'ruby193-rubygem-puppetdb_foreman':
  #  ensure => installed
  #}

  class { '::foreman' :
    version             => $foreman_version,
    unattended          => false,
    admin_username      => $foreman_admin_username,
    admin_password      => $foreman_admin_password,
    db_type             => $foreman_db_type,
    db_manage           => false,
    db_setup            => true,
    db_host             => $foreman_db_host,
    db_port             => $foreman_db_port,
    db_database         => $foreman_db_database,
    db_username         => $foreman_db_username,
    db_password         => $foreman_db_password,
    custom_repo         => true,
    configure_epel_repo => false,
    configure_scl_repo  => false,
    repo                => $foreman_repo,
    require             => [Class['::jana::os::pkgrepos::foreman'],
                            Class['::jana::os::pkgrepos::scl']],
  }

  cron { 'expire_reports':
    ensure  => present,
    command => '/usr/sbin/foreman-rake reports:expire days=90',
    user    => 'root',
    hour    => '0',
    minute  => '5',
  }

  cron { 'trend_push':
    ensure  => present,
    command => '/usr/sbin/foreman-rake trends:counter',
    user    => 'root',
    minute  => ['1', '31'],
  }
}
