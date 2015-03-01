# == Class: jana::roles::dc::master
#
# Create a FreeIPA master host.
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
class jana::roles::dc::master {
  include stdlib

  class { '::jana::os':
    ipa_setup => false,
    stage     => setup
  }

  # FIXME: There's an error in service order.  Also an errent /etc/hosts
  # entry shows up.
  class { '::jana::svc::ipa::master': }

}