# == Class: straycat::os::ipa_client
#
# <One line description>
#
# <Expanded class description>
#
# === Parameters
#
# [*<paramater>*]
#   <parameter description>
#
# === Examples
#
# class {'hubspot::classname':
#   param1 => value
# }
#
# === TODO
#
# * <things to do>
#
# === BUGS
#
# * <known issues>
#
# === Authors
#
# Tom McLaughlin <tmclaughlin@hubspot.com>
#
# === Copyright
#
# Copyright 2014 Hubspot
#
class straycat::os::ipa_client (
  $ipa_domain    = undef,
  $ipa_join_user = undef,
  $ipa_join_pass = undef,
  $ipa_realm     = undef,
  $ipa_server    = undef,
) {

  # FIXME: I don't like how this class works so do it on my own below.
  #class { '::ipa':
  #  domain      => 'straycat.local',
  #  realm       => 'STRAYCAT.LOCAL',
  #  otp         => 'YouDownWithOTP',  # FIXME: Need to better understand this.
  #  client      => true,
  #  automount   => false,
  #  sudo        => false,
  #  mkhomedir   => false,
  #  loadbalance => false
  #}

    exec { 'ipa-join':
      command => "ipa-client-install -U --enable-dns-updates --no-krb5-offline-passwords --domain=${ipa_domain} --realm=${ipa_realm} -p ${ipa_join_user} -w ${ipa_join_pass} -N --server=${ipa_server}",
      path    => ['/usr/sbin'],
      creates => '/etc/ipa/ca.crt'
    }
}
