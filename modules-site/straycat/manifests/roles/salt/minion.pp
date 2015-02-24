# == Class: straycat::roles::salt::minion
#
# Setup a Salt minion host.
#
# In a real environment all hosts would be minions.  Salt is just here as an
# experiment so it's not incorporated into Class[straycat::os].
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::roles::salt::minion {

  include stdlib

  class { '::straycat::os':
    stage => setup
  }

  class { '::straycat::svc::salt::minion': }

}