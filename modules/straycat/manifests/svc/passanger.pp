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
class straycat::svc::passenger {

  $passenger_version = '4.0.48'

  # Required for compilation.
  #
  ensure_resource('package', 'gcc-c++')

  class { '::passenger':
    package_ensure         => $passenger_version,
    passenger_version      => $passenger_version,
    package_provider       => 'gem',
    compile_passenger      => true,
    mod_passenger_location => "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}/buildout/apache2/mod_passenger.so",
    passenger_root         => "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}/",
    passenger_poolsize     => $::processorcount * 1.5,
    require                => Package['gcc-c++']
  }
  contain '::passenger'

}
