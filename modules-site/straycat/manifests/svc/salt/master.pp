class straycat::svc::salt::master (
  $salt_master_auto_accept = false
) {

  class { '::salt::master':
    master_auto_accept => $salt_master_auto_accept
  }

}