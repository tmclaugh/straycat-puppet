# == Class: straycat::os
#
# Basic OS setup
#
# === Parameters
#
# [*ipa_setup*]
#   If IPA client should be setup.  Useful for bypassing setup on IPA
#   masters and replicas.
#   Type: bool
#
# === Examples
#
#   class { '::straycay::os': }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os (
  $ipa_setup = true
) {

  include stdlib

  $ntp_hosts = hiera('straycat::infra::time')

# Vagrant likes to set the hostname ot 127.0.0.1 so we need to fix this.
# The resource below wwill not fix this.
#  host { 'localhost':
#    ip           => '127.0.0.1',
#    host_aliases => 'localhost.localdomain'
#  }
  exec { 'etc-hosts-localhost':
    command => 'sed -i \'s/127\.0\.0\.1.*/127.0.0.1\tlocalhost localhost.localdomain localhost4 localhost4.localdomain4/\' /etc/hosts',
    unless  => 'egrep "^127.0.0.1\slocalhost localhost.localdomain localhost4 localhost4.localdomain4$" /etc/hosts',
    path    => ['/bin', '/usr/bin'],
    notify  => Exec['nscd-flush-hosts']
  }

  if $::sc_dc =='local' and $::ipaddress_eth1 != undef {
    $hosts_addr = $::ipaddress_eth1
  } else {
    $hosts_addr = $::ipaddress_eth0
  }

  host { $::fqdn:
    ip           => $::hosts_addr,
    host_aliases => $::hostname,
    require      => Exec['etc-hosts-localhost']
  }

  exec { 'nscd-flush-hosts':
    command     => 'nscd -i hosts',
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    refreshonly => true,
    require     => Host[$::fqdn]
  }


  # repositories
  class { '::straycat::os::pkgrepos::epel': }

  class { '::ntp':
    servers        => $ntp_hosts,
    service_enable => true,
    service_ensure => running,
    service_manage => true
  }

  if $ipa_setup {
    class { '::straycat::os::ipa_client':
      require => Class['::ntp']
    }
    contain '::straycat::os::ipa_client'
  }
}
