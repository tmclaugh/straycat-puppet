# == Class: straycat::svc::puppet::foreman
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
#   class { '::straycat::svc::puppet::foreman':
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
class straycat::svc::puppet::foreman (
  $foreman_db_host     = undef,
  $foreman_db_username = undef,
  $foreman_db_password = undef
) {

  validate_string($foreman_db_host)
  validate_string($foreman_db_username)
  validate_string($foreman_db_password)

  # Just give up and use Foreman's setup.
  #contain ::straycat::svc::passenger

  $foreman_repo    = 'releases/1.7'
  $foreman_version = '1.7.0-1.el6'

  $foreman_db_type     = 'postgresql'
  $foreman_db_port     = '5432'
  $foreman_db_database = 'foreman'

  # Managing the repo on our own
  class { '::straycat::os::pkgrepos::foreman': }


  class { '::foreman' :
    version             => $foreman_version,
    unattended          => false,
    db_type             => $foreman_db_type,
    db_manage           => false,
    db_host             => $foreman_db_host,
    db_port             => $foreman_db_port,
    db_database         => $foreman_db_database,
    db_username         => $foreman_db_username,
    db_password         => $foreman_db_password,
    custom_repo         => true,
    configure_epel_repo => false,
    configure_scl_repo  => false,
    repo                => $foreman_repo,
    require             => Class['::straycat::os::pkgrepos::foreman']
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
