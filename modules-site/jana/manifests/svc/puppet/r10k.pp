# == Class: jana::svc::pupppet::r10k
#
# Install and configure r10k
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
# === FIXME
#
# * Move config to Hiera.
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::svc::puppet::r10k {

  # FIXME: move to hiera
  $version = '1.4.0'
  $git_url = 'https://github.com/tmclaugh/jana-puppet.git'
  class { '::r10k':
    version      => $version,
    remote       => $git_url,
    r10k_basedir => '/etc/puppet/environments',
    provider     => 'gem'
  }
  contain '::r10k'

}
