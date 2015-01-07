# == Class: straycat::roles::bootstrap
#
# Create a bootstrap puppetmaster.
#
# This will create a host to be a temporary puppetmaster. The host will be
# used to configure basic services.  Once that is done and basics are in
# place (ex. puppetmaster, puppetdb, foreman) then this host can be removed.
#
# === Parameters
#
# NONE
#
# === Examples
#
# This role should be applied to a host via an ENC.
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::roles::bootstrap {
  include stdlib

  # Not meant to be a fully functional host.
  #class { '::straycat::os':
  #  stage => setup
  #}

  class { '::straycat::svc::puppet::master':
    bootstrap       => true,
    generate_ca     => true,
    puppet_psk      => '',
    enable_puppetdb => false,
    enable_foreman  => false
  }

}
