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
class straycat::os::ipa_client {

  class { '::ipa':
    domain      => 'straycat.local',
    realm       => 'STRAYCAT.LOCAL',
    otp         => 'YouDownWithOTP',  # FIXME: Need to better understand this.
    client      => true,
    automount   => false,
    sudo        => false,
    mkhomedir   => false,
    loadbalance => false
  }
}
