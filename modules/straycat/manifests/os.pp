# == Class: straycat::os
#
# Short description of class.
#
# === Parameters
#
# [*parameter*]
#   Description of parameter and its usage.
#
# === Examples
#
#   class { 'class_name':
#     parameter => 'value'
#   }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os {

  include stdlib

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

  # FIXME: This breaks our Vagrant setup which uses eth1 for internal
  # network communication.
  host { $::fqdn:
    ip           => $::ipaddress_eth0,
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
    servers        => ['time.straycat.dhs.org'],
    service_enable => true,
    service_ensure => running,
    service_manage => true
  }

}
