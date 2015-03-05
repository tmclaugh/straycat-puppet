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

  if $::operatingsystem == 'centos' {
    class { '::jana::os::pkgrepos::centos': }
    contain '::jana::os::pkgrepos::centos'

    class { '::jana::os::pkgrepos::epel': }
    contain '::jana::os::pkgrepos::epel'

    Class['::jana::os::pkgrepos::centos'] ->
    Class['::jana::os::pkgrepos::epel']
  } elsif $::operatingsystem == 'debian' {

    class { '::apt':
      always_apt_update    => false,
      apt_update_frequency => undef,
      disable_keys         => undef,
      proxy_host           => false,
      proxy_port           => '8080',
      purge_sources_list   => true,
      purge_sources_list_d => true,
      purge_preferences_d  => true,
      update_timeout       => undef,
      fancy_progress       => true
    }

    class { '::apt::release':
      release_id => $::lsbdistcodename,
    }

    class { '::jana::os::pkgrepos::debian': }

    Class['::apt'] ->
     Class['apt::release'] ->
      Class['::jana::os::pkgrepos::debian']
  }
}

