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
class straycat::roles::postgresql {

  include stdlib

  $pgsql_db_name        = 'puppetdb'
  $pgsql_db_user        = 'puppetdb'
  $pgsql_db_passwd      = 'MyWeakPassword' # Move to Hiera when in place

  $foreman_db_name        = 'foreman'
  $foreman_db_user        = 'foreman'
  $foreman_db_passwd      = 'MyWeakPassword' # Move to Hiera when in place

  class { 'straycat::os':
    stage => setup
  }

  class { '::straycat::svc::postgresql': }

  ::straycat::svc::postgresql::db { $pgsql_db_name:
    db_user   => $pgsql_db_user,
    db_passwd => $pgsql_db_passwd
  }

  ::straycat::svc::postgresql::db { $foreman_db_name:
    db_user   => $foreman_db_user,
    db_passwd => $foreman_db_passwd
  }
}
