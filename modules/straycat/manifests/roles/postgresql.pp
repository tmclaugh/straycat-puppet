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
# tmclaughlin@hubspot.com
#
# === Copyright
#
# Copyright 2014 Hubspot
#
class straycat::roles::postgresql {

  include stdlib

  $pgsql_db_name        = 'puppetdb'
  $pgsql_db_user        = 'puppetdb'
  $pgsql_db_passwd      = 'MyWeakPassword' # Move to Hiera when in place

  class { 'straycat::os':
    stage => setup
  }

  class { '::straycat::svc::postgresql':
    pgsql_config_entries => $pgsql_config_hash
  }

  ::straycat::svc::postgresql::db { 'puppetdb':
    db_user   => $pgsql_db_user,
    db_passwd => $pgsql_db_passwd
  }

}
