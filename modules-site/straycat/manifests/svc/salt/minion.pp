class straycat::svc::salt::minion (
  $salt_minion_master
) {

  class { '::salt::minion':
    minion_master => $salt_minion_master
  }

}