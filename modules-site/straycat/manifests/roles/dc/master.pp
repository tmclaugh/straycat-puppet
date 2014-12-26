# == Class: class_name
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
class straycat::roles::dc::master {
  include stdlib

  class { 'straycat::os':
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
