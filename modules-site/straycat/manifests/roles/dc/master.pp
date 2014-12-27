# == Class: straycat::roles::dc::master
#
# Create a FreeIPA master host.
#
# === Examples
#
# This should be attached to a host via an ENC.
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::roles::dc::master {
  include stdlib

  class { '::straycat::os':
    ipa_setup => false,
    stage     => setup
  }

  $ipa_master_conf = {master     => true,
                      domain     => 'straycat.local',
                      realm      => 'STRAYCAT.LOCAL',
                      adminpw    => 'ThisIsTheAdminPasswd',
                      dspw       => 'NotSureWhatThisIs',
                      dns        => true,
                      forwarders => ['8.8.8.8', '8.8.4.4']}

  # FIXME: There's an error in service order.  Also an errent /etc/hosts
  # entry shows up.
  class { '::straycat::svc::ipa::master':
    ipa_master_conf => $ipa_master_conf,
  }

}
