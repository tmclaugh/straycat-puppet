# == Class: straycat::roles::cassandra
#
# Setup Cassandra DB
#
# === Examples
#
# This role should be attached to a host via an ENC.
#
# === TODO
#
# * This sets up a node but will need some more work to figure out how to
#   handle creating clusters based off of this role.  Maybe there should be
#   two roles, seed and node, but not sure that will be effective.  How
#   would one of those roles affect change in the environment?
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
#
class straycat::roles::cassandra{

  class { '::straycat::os': }
  class { '::straycat::svc::cassandra': }

}
