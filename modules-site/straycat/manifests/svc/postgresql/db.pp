# == Define: straycat::svc::postgresql::db
#
# Create a DB on a pgsql host
#
# === Parameters
#
# [*db_user*]
#   Owner of database.
#   Type: string
#
# [*db_passwd*]
#   Password for database
#   Type: string
#
# [*db_name*]
#   Name of database; typically $name
#   Type: string
#
# [*auth_method*]
#   Auth method for owner.
#   Type: string
#
# [*address*]
#   Address oner access rule should be valid for
#   Type: string
#
# === Examples
#
# straycat::svc::postgresql::db { 'supercoolapp':
#   db_user   => 'supercool',
#   db_passwd => 'MyPasswordForThisDB'
# }
#
# === BUGS
#
# * We have no good way of having a DB on the pgsql host being realized in
#   time for an app on another host to work.  Right now just adding
#   resources directly to pgsql role class but still need to make sure
#   Puppet has run on there before new app host has been started up.
#
# * Authn/authz could be more robust.
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Straycat
#
define straycat::svc::postgresql::db (
  $db_user     = undef,
  $db_passwd   = undef,
  $db_name     = $name,
  $auth_method = 'md5',
  $address     = '0.0.0.0/0',
) {

  validate_string($db_user)
  validate_string($db_passwd)

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
