# == Class: jana::roles::foreman
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
class jana::roles::foreman {

  include stdlib

  class { 'jana::os':
    stage => setup
  }

  class { '::jana::svc::puppet::foreman': }

}
