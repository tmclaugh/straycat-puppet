# == Class: straycat::os::pkgrepos
#
# Install some standard yum repos.
#
# === Examples
#
# class { '::straycat::os::pkgrepos': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os::pkgrepos {

  class { '::straycat::os::pkgrepos::centos': }
  contain '::straycat::os::pkgrepos::centos'

  class { '::straycat::os::pkgrepos::epel': }
  contain '::straycat::os::pkgrepos::epel'

  Class['::straycat::os::pkgrepos::centos'] ->
  Class['::straycat::os::pkgrepos::epel']

}
