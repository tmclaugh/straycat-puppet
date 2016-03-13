# == Class: straycat::os::setup
#
# OS setup
#
# These resources should be realized before we start establishing service or
# role resources.
#
# === Parameters
#
# [*parameter*]
#   Descripotion.
#   Type: bool
#
# === Examples
#
# class { '::class::name' }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2015 Tom McLaughlin
#
class straycat::os::setup (
  $ipa_setup,
  $puppet_setup
) {

  include concat::setup

  anchor { 'straycat::os::setup::start': }

  class { '::straycat::os::logging': }

  $real_ipa_setup = pick($::sc_ipa_setup, $ipa_setup)
  class { '::straycat::os::resolv': }

  # repositories
  class { '::straycat::os::pkgrepos': }

  class { '::straycat::os::time': }

  if $puppet_setup {
    class { '::straycat::os::puppet':
      require => Class['::straycat::os::time']
    }
    contain '::straycat::os::puppet'
  }

  if $real_ipa_setup {
    class { '::straycat::os::ipa_client':
      require => Class['::straycat::os::time']
    }
    contain '::straycat::os::ipa_client'
  }

  class { '::straycat::os::user': }

  # Since we have no ENC and have some Vagrant profiles that send the role as
  # a fact. This ensures we don't have to remember to run puppet with the role
  # fact set in the environment every time.  The site_svc fact is useful
  # in multi-host environments with a single puppetmaster.
  if $::site_env == 'dev' or $::role {
    $fact_file = '/etc/facter/facts.d/straycat.txt'
    file { $fact_file:
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Class['::straycat::os::puppet']
    }

    if $::role {
      file_line { 'facter_role':
        path    => $fact_file,
        match   => 'role=.*',
        line    => "role=${::role}",
        require => File[$fact_file]
      }
    }

    if $::site_env == 'dev' {
      file_line { 'facter_site_svc':
        path    => $fact_file,
        match   => 'site_svc=.*',
        line    => "site_svc=${::site_svc}",
        require => File[$fact_file]
      }
    }
  }

  anchor { 'straycat::os::setup::end': }

  Anchor['straycat::os::setup::start'] ->
  Class['::straycat::os::logging'] ->
  Class['::straycat::os::resolv'] ->
  Class['::straycat::os::pkgrepos'] ->
  Class['::straycat::os::time'] ->
  Class['::straycat::os::user'] ->
  Anchor['straycat::os::setup::end']

}
