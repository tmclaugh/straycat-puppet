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
class straycat::roles::foreman {

  include stdlib

  $foreman_db_host     = 'pgsql.straycat.local'
  $foreman_db_username = 'foreman'
  $foreman_db_password = 'MyWeakPassword' # Move to Hiera when in place

  class { 'straycat::os':
    stage => setup
  }

  class { '::straycat::svc::puppet::foreman':
    foreman_db_host     => $foreman_db_host,
    foreman_db_username => $foreman_db_username,
    foreman_db_password => $foreman_db_password
  }

}
