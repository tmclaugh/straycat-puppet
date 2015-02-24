# == Class: straycat::roles::salt::master
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
class straycat::roles::salt::master {

  include stdlib

  if $::sc_dc == 'local' {
    $salt_master_auto_accept = true
  } else {
    $salt_master_auto_accept = false
  }

  class { '::straycat::os':
    stage => setup
  }

  class { '::straycat::svc::salt::master':
    salt_master_auto_accept => $salt_master_auto_accept
  }

}