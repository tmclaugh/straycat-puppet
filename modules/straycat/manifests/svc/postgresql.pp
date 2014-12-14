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
# tmclaugh@sdf.lonestar.org
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
