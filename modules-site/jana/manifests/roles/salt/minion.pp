# == Class: jana::roles::salt::minion
#
# Setup a Salt minion host.
#
# In a real environment all hosts would be minions.  Salt is just here as an
# experiment so it's not incorporated into Class[jana::os].
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::roles::salt::minion {

  include stdlib

  class { '::jana::os':
    stage => setup
  }

  class { '::jana::svc::salt::minion': }

}