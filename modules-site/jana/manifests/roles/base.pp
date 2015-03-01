# == Class: jana::roles::base
#
# Setup a host with basic configuration.
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::roles::base {

  class { '::jana::os': }

}
