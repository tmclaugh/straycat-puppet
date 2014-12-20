# == Class: straycat::svc::passenger
#
# Installs Passenger
#
# === Parameters
#
# NONE
#
# === Examples
#
# class { '::straycat::svc::passenger': }
#
# === TODO
#
# * evaluate using SCL repo package and Ruby 193.
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::svc::passenger {

  $passenger_version = '4.0.18'
  $passenger_pkg_release = "${passenger_version}-9.6.${::centos_pkg_release}"

  # We need 4.0.x for Foreman but SCL was a pain.  Just use the Foreman pkgs
  class { '::straycat::os::pkgrepos::foreman': }

  class { '::passenger':
    package_name           => 'mod_passenger',
    package_ensure         => $passenger_pkg_release,
    passenger_version      => $passenger_version, # Used only to distinguish v3 v. v4
    package_provider       => 'yum',
    mod_passenger_location => '/usr/lib64/httpd/modules/mod_passenger.so',
    passenger_root         => "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}/",
    passenger_poolsize     => $::processorcount * 1.5,
    passenger_ruby         => '/usr/bin/ruby',
    require                => Class['::straycat::os::pkgrepos::foreman']
  }

  contain '::passenger'

}
