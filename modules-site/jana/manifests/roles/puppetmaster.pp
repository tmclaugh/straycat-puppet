# == Class: jana::roles::puppetmaster
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
class jana::roles::puppetmaster {

  include stdlib

  $foreman_url = 'https://foreman.jana.local'

  $puppet_psk = 'FoiWssfp1wOfbdQ4'
  $puppet_puppetdb_host = 'puppetmaster.jana.local'

  $puppetdb_database_host     = 'pgsql.jana.local'
  $puppetdb_database_name     = 'puppetdb'
  $puppetdb_database_username = 'puppetdb'
  $puppetdb_database_password = 'MyWeakPassword' # Move to Hiera when in place

  $pgsql_config_hash = {
    effective_cache_size => { value => '512MB' },
    maintenance_work_mem => { value => '64MB' }
  }

  class { 'jana::os':
    puppet_setup => false, # Causes resource order issue due to puppetmaster
    stage        => setup
  }

  class { '::jana::os::puppet': }

  class { '::jana::svc::puppet::master':
    foreman_url   => $foreman_url,
    puppet_psk    => $puppet_psk,
    puppetdb_host => $puppet_puppetdb_host,
  }

  class { '::jana::svc::puppet::db':
    puppetdb_database_host     => $puppetdb_database_host,
    puppetdb_database_name     => $puppetdb_database_name,
    puppetdb_database_username => $puppetdb_database_username,
    puppetdb_database_password => $puppetdb_database_password,
    require                    => Class['::jana::svc::puppet::master']
  }

  # Don't setup until service is operational.
  class { '::jana::svc::puppet::foreman_proxy':
    require => [Class['::jana::svc::puppet::master'],
                Class['::jana::svc::puppet::db']]
  }

}
