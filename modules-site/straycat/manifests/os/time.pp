# == Class: straycat::os::time
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
# class { 'straycat::os::time': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os::time (
  $ntp_servers = undef,
) {

  validate_array($ntp_servers)

  class { '::ntp':
    servers        => $ntp_servers,
    service_enable => true,
    service_ensure => running,
    service_manage => true
  }
  contain '::ntp'

}
