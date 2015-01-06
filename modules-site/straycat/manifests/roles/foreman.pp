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

  class { 'straycat::os':
    stage => setup
  }

  class { '::straycat::svc::puppet::foreman': }

}
