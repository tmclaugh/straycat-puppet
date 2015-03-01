# == Class: jana::os::pkgrepos
#
# Install some standard yum repos.
#
# === Examples
#
# class { '::jana::os::pkgrepos': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::os::pkgrepos {

  class { '::jana::os::pkgrepos::centos': }
  contain '::jana::os::pkgrepos::centos'

  class { '::jana::os::pkgrepos::epel': }
  contain '::jana::os::pkgrepos::epel'

  Class['::jana::os::pkgrepos::centos'] ->
  Class['::jana::os::pkgrepos::epel']

}
