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