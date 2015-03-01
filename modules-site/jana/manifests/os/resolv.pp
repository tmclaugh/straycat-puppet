# == Class: jana::os::resolv
#
# Configure name resolution
#
# === Parameters
#
# [*nameservers*]
#   List of nameservers to use.
#   Type: array
#
# [*domain*]
#   'domain' for resolv.conf
#   Type: string
#
# === Examples
#
# class { '::jana::os::resolv': }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::os::resolv (
  $nameservers = undef,
  $domainname  = undef,
) {

  validate_array($nameservers)
  validate_string($domain)

  ### /etc/hosts
  #
  #Vagrant likes to set the hostname ot 127.0.0.1 so we need to fix this.
  #The resource below wwill not fix this.
  #
  #host { 'localhost':
  #  ip           => '127.0.0.1',
  #  host_aliases => 'localhost.localdomain'
  #}
  exec { 'etc-hosts-localhost':
    command => 'sed -i \'s/127\.0\.0\.1.*/127.0.0.1\tlocalhost localhost.localdomain localhost4 localhost4.localdomain4/\' /etc/hosts',
    unless  => 'egrep "^127.0.0.1\slocalhost localhost.localdomain localhost4 localhost4.localdomain4$" /etc/hosts',
    path    => ['/bin', '/usr/bin'],
    notify  => Exec['nscd-flush-hosts']
  }

  if $::jm_dc =='local' and $::ipaddress_eth1 != undef {
    $hosts_addr = $::ipaddress_eth1
  } else {
    $hosts_addr = $::ipaddress_eth0
  }

  host { $::fqdn:
    ip           => $hosts_addr,
    host_aliases => $::hostname,
    require      => Exec['etc-hosts-localhost']
  }

  ### /etc/resolv.conf
  class { '::resolv_conf':
    domainname  => $domainname,
    nameservers => $nameservers
  }
  contain '::resolv_conf'

  ### cleanup
  exec { 'nscd-flush-hosts':
    command     => 'nscd -i hosts',
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    refreshonly => true,
    require     => [Host[$::fqdn], Class['::resolv_conf']]
  }


}
