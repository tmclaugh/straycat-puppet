# == Class: straycat::os::ipa_client
#
# Setup IPA client
#
# === Parameters
#
# [*ipa_domain*]
#   Name of IPA domain.
#   Type: string
#
# [*ipa_join_user*]
#   User to perform join operation as.
#   Type: string
#
# [*ipa_join_pass*]
#   Password of join user
#   Type: string
#
# [*ipa_realm*]
#   Nae of IPA realm.  (Typically just the domain capitalized.)
#   Type: string
#
# [*ipa_server*]
#   IPA server to perform operation against.
#   Type: string
#
# === Examples
#
# class { '::straycat::os::ipa_client':
#   ipa_domain    => 'domain.lan'
#   ipa_realm     => 'DOMAIN.LAN'
#   ipa_join_user => 'join_user'
#   ipa_join_pass => 'joinPasswd'
#   ipa_server    => 'ipa.domain.dev'
# }
#
# === TODO
#
# * Manage PAM, nsswitch, SSD config here?
#
# === BUGS
#
# * Need to handle not joining to a domain.
#
# === Authors
#
# Tom McLaughlin <tmclaugh@gmail.com>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os::ipa_client (
  $ipa_domain    = undef,
  $ipa_join_user = undef,
  $ipa_join_pass = undef,
  $ipa_otp       = undef,
  $ipa_realm     = undef,
  $ipa_server    = undef,
) {

  # FIXME: I don't like how this class works so do it on my own below.
  class { '::ipa':
    domain      => $ipa_domain,
    realm       => $ipa_realm,
    otp         => $ipa_otp,    # Not sure what this is for or if even needed.
    client      => true,
    automount   => false,
    sudo        => false,
    mkhomedir   => false,
    loadbalance => false
  }

  exec { 'ipa-join':
    command => "ipa-client-install -U --preserve-sssd --no-ntp --enable-dns-updates --no-krb5-offline-passwords --domain=${ipa_domain} --realm=${ipa_realm} -p ${ipa_join_user} -w ${ipa_join_pass} -N --server=${ipa_server}",
    path    => ['/usr/sbin'],
    creates => '/etc/ipa/ca.crt',
    before  => Service[sssd]
  }
}
