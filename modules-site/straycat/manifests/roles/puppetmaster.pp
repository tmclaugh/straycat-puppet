# == Class: straycat::roles::puppetmaster
#
# Setup a Puppetmaster.  A puppetmaster handles both master and PuppetDB
# duties.
#
# === Examples
#
# This should be attached to a host via an ENC.
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::roles::puppetmaster {

  include stdlib

  $foreman_url = 'http://foreman.straycat.local'

  $puppet_psk = 'FoiWssfp1wOfbdQ4'
  $puppet_puppetdb_host = 'localhost'

  $puppetdb_database_host     = 'pgsql.straycat.local'
  $puppetdb_database_name     = 'puppetdb'
  $puppetdb_database_username = 'puppetdb'
  $puppetdb_database_password = 'MyWeakPassword' # Move to Hiera when in place

  $pgsql_config_hash = {
    effective_cache_size => { value => '512MB' },
    maintenance_work_mem => { value => '64MB' }
  }

  class { 'straycat::os':
    stage => setup
  }

  class { '::straycat::svc::puppet::master':
    foreman_url   => $foreman_url,
    puppet_psk    => $puppet_psk,
    puppetdb_host => $puppet_puppetdb_host,
  }

  class { '::straycat::svc::puppet::db':
    puppetdb_database_host     => $puppetdb_database_host,
    puppetdb_database_name     => $puppetdb_database_name,
    puppetdb_database_username => $puppetdb_database_username,
    puppetdb_database_password => $puppetdb_database_password,
    require                    => Class['::straycat::svc::puppet::master']
  }

}
