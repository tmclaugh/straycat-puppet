# == Class: straycat::roles::postgresql
#
# Setup a PostgreSQL server in the environment
#
# === Examples
#
# This should be attached to a host via an ENC
#
# === BUGS
#
# * We have no good way of having a DB on the pgsql host being realized in
#   time for an app on another host to work.  Right now just adding
#   resources directly to pgsql role class but still need to make sure
#   Puppet has run on there before new app host has been started up.
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::roles::postgresql {

  $pgsql_db_name        = 'puppetdb'
  $pgsql_db_user        = 'puppetdb'
  $pgsql_db_passwd      = 'MyWeakPassword' # Move to Hiera when in place

  $foreman_db_name        = 'foreman'
  $foreman_db_user        = 'foreman'
  $foreman_db_passwd      = 'MyWeakPassword' # Move to Hiera when in place

  class { 'straycat::os': }

  class { '::straycat::svc::postgresql': }
  class { '::straycat::svc::phppgadmin':
    require => Class['::straycat::svc::postgresql']
  }

  ::straycat::svc::postgresql::db { $pgsql_db_name:
    db_user   => $pgsql_db_user,
    db_passwd => $pgsql_db_passwd
  }

  ::straycat::svc::postgresql::db { $foreman_db_name:
    db_user   => $foreman_db_user,
    db_passwd => $foreman_db_passwd
  }
}
