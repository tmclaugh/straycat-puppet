# == Class: jana::svc::salt::minion
#
# Setup a Salt minion
#
# We only use this class for testing and experimentation with Salt.
#
# === Parameters
#
# [*salt_minion_master*]
#   Hostname of master.
#   Type: string
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
class jana::svc::salt::minion (
  $salt_minion_master
) {

  class { '::salt::minion':
    minion_master => $salt_minion_master
  }

}