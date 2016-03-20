# == Class: straycat::svc::puppet::foreman_proxy
#
# Setup Foreman proxy service
#
# === Parameters
#
# [*<paramater>*]
#   <parameter description>
#
# === Examples
#
# class { '::straycat::svc::puppet::foreman_proxy':
#   param1 => value
# }
#
# === TODO
#
# * FreeIPA support
#
# * Decide if $register_in_foreman should be enabled. Hate exported
#   resources.  Can this be done better?
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
#
class straycat::svc::puppet::foreman_proxy (
  $foreman_host = undef
){

  validate_string($foreman_host)

  $foreman_proxy_version = '1.7.1-1.el6'

  # We have issues with having no valid CA when local so just make it open to
  # the world.
  if $::site_dc == 'local' {
    $trusted_hosts = []
  } else {
    $trusted_hosts = ["${foreman_host}", "${::fqdn}"]
  }

  class { '::foreman_proxy':
    version             => $foreman_proxy_version,
    custom_repo         => false,
    dhcp                => false,
    dns                 => false,
    foreman_base_url    => "https://${foreman_host}",
    puppetdir           => '/etc/puppet',
    ssldir                => '/var/lib/puppet/ssl',   # Used by PuppetCA functionality
    realm               => false, # Would like to get freeipa later.
    register_in_foreman => true,
    tftp                => false,
    trusted_hosts       => $trusted_hosts,
    use_sudoersd        => true,
    manage_sudoersd     => false,
    puppetca_cmd        => '/usr/bin/puppet cert',
    puppetrun_cmd       => '/usr/bin/puppet kick',
    ssl                   => true,
    ssl_key               => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    ssl_cert              => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    ssl_ca                => "/var/lib/puppet/ssl/certs/ca.pem",
  }
  contain ::foreman_proxy

  # * $puppet_home and $puppetdir was not set and ssl certs and conf
  #   locations are wrong.
  # * sudeoers tens to break stuff.

}
