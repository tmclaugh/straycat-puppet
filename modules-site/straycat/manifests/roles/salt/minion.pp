class straycat::roles::salt::minion {

  include stdlib

  class { '::straycat::os':
    stage => setup
  }

  class { '::straycat::svc::salt::minion': }

}