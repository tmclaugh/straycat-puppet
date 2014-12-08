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
# tmclaughlin@hubspot.com
#
# === Copyright
#
# Copyright 2014 Hubspot
#
class straycat::roles::dc::master {
  include stdlib

  class { 'straycat::os':
    stage => setup
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
