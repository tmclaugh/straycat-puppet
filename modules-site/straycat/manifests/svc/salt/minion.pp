# == Class: straycat::svc::salt::minion
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
#   class { '::straycat::svc::salt::master': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::svc::salt::minion (
  $salt_minion_master
) {

  class { '::salt::minion':
    minion_master => $salt_minion_master
  }

}