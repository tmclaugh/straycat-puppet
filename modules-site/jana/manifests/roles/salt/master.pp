# == Class: jana::roles::salt::master
#
# Setup a Salt master host.
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::roles::salt::master {

  include stdlib

  if $::jm_dc == 'local' {
    $salt_master_auto_accept = true
  } else {
    $salt_master_auto_accept = false
  }

  class { '::jana::os':
    stage => setup
  }

  class { '::jana::svc::salt::master':
    salt_master_auto_accept => $salt_master_auto_accept
  }

}