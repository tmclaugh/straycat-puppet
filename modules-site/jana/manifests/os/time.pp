# == Class: jana::os::time
#
# Setup time keeping using NTPD.
#
# === Parameters
#
# [*ntp_servers*]
#   List of NTP servers.
#   Type: array
#
# === Examples
#
# class { 'jana::os::time': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::os::time (
  $ntp_servers = undef,
  $timezone    = UTC
) {

  validate_array($ntp_servers)

  class { '::timezone':
    timezone => $timezone,
  }
  contain '::timezone'

  class { '::ntp':
    servers        => $ntp_servers,
    service_enable => true,
    service_ensure => running,
    service_manage => true,
    require        => Class['::timezone']
  }
  contain '::ntp'

}
