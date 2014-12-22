# == Class: straycat::svc::pupppet::r10k
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
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::svc::puppet::r10k {

  # FIXME: move to hiera
  $version           = '1.4.0'
  $git_host          = 'git.straycat.dhs.org'
  $git_url           = "gitolite@${git_host}:puppet.git"
  $git_host_key_type = 'ssh-rsa'
  $git_host_key      = 'AAAAB3NzaC1yc2EAAAABIwAAAQEAvn2el8mkkx8fKK4tnswlISXa7bLRaxn/rAXigP9Cvls0q9LARUBws1XTCbIz8NpXjuG5u7x4KMANyg0O7ja+CjdB+SBt3wk27VPtgF8D70K9Xh9e8/LjeoY3ALpEYMNwrNX8CjARz5J2V8caSj3479IB/ruHUC6J0LEZgLH4zEV87pTle8mL2c3iG4TR1Lc1wstu41ZVjed0xzXjnfI85No8h1xLxgnuz68nrfkb+SgzkPOFGLv4T/oFfzr5R0rbewHHLMxKHxtgWUFr4JdibJdfMHQSu0g0TbyjR5PmhOpmBsPS2OozorYAkUtYGhrDtr1B02dn82J4d/AGWLP24Q=='

  file { '/root/.ssh/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  sshkey { $git_host:
    ensure  => 'present',
    target  => '/root/.ssh/known_hosts',
    type    => $git_host_key_type,
    key     => $git_host_key,
    require => File['/root/.ssh/']
  }

  class { '::r10k':
    version      => $version,
    remote       => $git_url,
    r10k_basedir => '/etc/puppet/environments',
    provider     => 'gem'
  }
  contain '::r10k'


}
