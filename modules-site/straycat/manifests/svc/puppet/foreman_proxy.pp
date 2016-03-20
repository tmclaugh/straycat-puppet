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

  class { '::foreman_proxy':
    custom_repo         => false,
    dhcp                => false,
    dns                 => false,
    foreman_base_url    => "https://${foreman_host}",
    puppetdir           => '/etc/puppet',
#    puppet_home         => '/var/lib/puppet',
    realm               => false, # Would like to get freeipa later.
    register_in_foreman => false,
    tftp                => false,
    trusted_hosts       => [$foreman_host, $::fqdn],
    use_sudoersd        => true,
    manage_sudoersd     => false,
    puppetca_cmd        => '/usr/bin/puppet cert',
    puppetrun_cmd       => '/usr/bin/puppet kick',
  }
  contain ::foreman_proxy

  # * $puppet_home and $puppetdir was not set and ssl certs and conf
  #   locations are wrong.
  # * sudeoers tens to break stuff.

}
