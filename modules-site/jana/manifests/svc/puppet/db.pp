# == Class: jana::svc::puppet::db
#
# Setup PuppetDB
#
# === Parameters
#
# [*puppetdb_database_host*]
#   Hostname of SQL DB server.
#   Type: string
#
# [*puppetdb_database_username*]
#   Username to access SQL DB.
#   Type: string
#
# [*puppetdb_database_password*]
#   Password to access SQL DB.
#   Type: string
#
# [*puppetdb_database_name*]
#   Name of SQL DB.
#   Type: string
#
# [*puppetdb_listen_address*]
#   Address PuppetDB should listen on.
#   Type: string
#
# [*puppetdb_node_ttl*]
#   TTL of a node for which no report has been received.  This threshold
#   will mark the host as inactive.
#   Type: string
#
# [*puppetdb_node_purge_ttl*]
#   TTL of a node after it's been marked as inactive and will then be
#   purged.
#   Type: string
#
# [*puppetdb_report_ttl*]
#   TTL of reports
#   Type: string
#
# [*puppetdb_ssl_listen_address*]
#   Address PuppetDB should listen on for SSL connections
#   Type: string
#
# [*puppetdb_version*]
#   Version of PuppetDB
#   Type: string
#
# [*puppetdb_extra_conf*]
#   Extra configuration to pass to Class['::puppetdb']
#   Type: hash
#
# === Examples
#
#   class { '::jana::svc::puppet::db': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::svc::puppet::db (
  $puppetdb_database_host      = undef,
  $puppetdb_database_username  = undef,
  $puppetdb_database_password  = undef,
  $puppetdb_database_name      = 'puppetdb',
  $puppetdb_listen_address     = '0.0.0.0',
  $puppetdb_node_ttl           = '14d', # How long till a node is declared inactive
  $puppetdb_node_purge_ttl     = '14d', # how long after being inactive before it purges
  $puppetdb_report_ttl         = '14d',
  $puppetdb_ssl_listen_address = '0.0.0.0',
  $puppetdb_version            = "2.2.2-1.${::centos_pkg_release}",
  $puppetdb_extra_conf         = {},
) {

  validate_string($puppetdb_database_host)
  validate_string($puppetdb_database_username)
  validate_string($puppetdb_database_password)

  $puppetdb_conf_hash = {
    database_host      => $puppetdb_database_host,
    database_name      => $puppetdb_database_name,
    database_username  => $puppetdb_database_username,
    database_password  => $puppetdb_database_password,
    listen_address     => $puppetdb_listen_address,
    node_ttl           => $puppetdb_node_ttl,
    node_purge_ttl     => $puppetdb_node_purge_ttl,
    puppetdb_version   => $puppetdb_version,
    report_ttl         => $puppetdb_report_ttl,
    ssl_listen_address => $puppetdb_ssl_listen_address,
  }

  $puppetdb_conf = merge($puppetdb_conf_hash, $puppetdb_extra_conf)

  file { ['/srv/puppetdb',
          '/srv/puppetdb/db',
          '/srv/puppetdb/state']:
    ensure  => directory,
    owner   => 'puppetdb',
    group   => 'puppetdb',
    mode    => '0755',
    require => Package['puppetdb']
  }

  file { '/srv/puppetdb/config':
    ensure  => link,
    target  => '/etc/puppetdb/conf.d',
    require => File['/srv/puppetdb']
  }

#  file { '/var/lib/puppetdb':
#    ensure  => link,
#    force   => true,
#    target  => '/srv/puppetdb',
#    require => File['/srv/puppetdb'],
#    before  => Service['puppetdb']
#  }

  # We don't use Class[puppetdb] because it will setup pgsql
  ensure_resource('class', '::puppetdb::server', $puppetdb_conf)

}
