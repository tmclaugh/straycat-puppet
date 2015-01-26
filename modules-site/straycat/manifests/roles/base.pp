# == Class: straycat::roles::base
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
class straycat::roles::base {

  class { '::straycat::os': }

}
