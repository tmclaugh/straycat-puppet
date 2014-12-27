# == Class: straycat::roles::foreman
#
# Create a foreman host.
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
class straycat::roles::foreman {

  include stdlib

  $foreman_admin_username = 'admin'
  $foreman_admin_password = 'changeme'

  $foreman_db_host     = 'pgsql.straycat.local'
  $foreman_db_username = 'foreman'
  $foreman_db_password = 'MyWeakPassword' # Move to Hiera when in place

  class { 'straycat::os':
    stage => setup
  }

  class { '::straycat::svc::puppet::foreman':
    foreman_admin_username => $foreman_admin_username,
    foreman_admin_password => $foreman_admin_password,
    foreman_db_host        => $foreman_db_host,
    foreman_db_username    => $foreman_db_username,
    foreman_db_password    => $foreman_db_password
  }

}
