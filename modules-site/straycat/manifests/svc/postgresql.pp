# == Class: straycat::svc::postgresql
#
# Setup the PostgreSQL service
#
# === Parameters
#
# [*pgsql_datadir*]
#   Location of postgresql data.
#   Type: string
#
# [*pgsql_listen_addressr*]
#   Address Postgresql should listen on.
#   Type: string
#
# [*pgsql_config_entries*]
#   Additional configuration to pass to Class['::postgresql']
#   Type: hash
#
# === Examples
#
#   class { '::straycat::svc::postgresql': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::svc::postgresql (
  $pgsql_datadir        = '/srv/postgresql',
  $pgsql_listen_address = '0.0.0.0',
  $pgsql_config_entries = {}
) {


  # These are our defaults
  $pgsql_config_entries_hash = {
    effective_cache_size => { value => '512MB' },
    maintenance_work_mem => { value => '64MB' }
  }

  $pgsql_config_entries_merged = merge($pgsql_config_entries_hash, $pgsql_config_entries)

  class { '::postgresql::server':
    datadir              => $pgsql_datadir,
    pg_hba_conf_path     => "${pgsql_datadir}/pg_hba.conf",
    postgresql_conf_path => "${pgsql_datadir}/postgresql.conf",
    listen_addresses     => $pgsql_listen_address
  }

  create_resources('postgresql::server::config_entry', $pgsql_config_entries_merged)

  contain '::postgresql::server'

}
