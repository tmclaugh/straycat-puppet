# == Class: jana::svc::salt::master
#
# Setup a Salt master host
#
# === Parameters
#
# [*salt_master_auto_accept*]
#   Should the master automatically accept new minions?  Useful to enable to
#   'true' in Vagrant setups.  Otherwise do not!
#   Type: bool
#
# === Examples
#
#   class { '::jana::svc::salt::master': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::svc::salt::master (
  $salt_master_auto_accept = false
) {

  class { '::salt::master':
    master_auto_accept => $salt_master_auto_accept
  }

}