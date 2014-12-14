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
define straycat::svc::postgresql::db (
  $db_user,
  $db_passwd,
  $db_name     = $name,
  $auth_method = 'md5',
  $address     = '0.0.0.0/0',
) {

  postgresql::server::db { $db_name:
    user     => $db_user,
    password => $db_passwd
  }

  postgresql::server::pg_hba_rule { "${db_name}/${db_user}":
    type        => 'host',
    database    => $db_name,
    user        => $db_user,
    auth_method => $auth_method,
    address     => $address
  }
}
