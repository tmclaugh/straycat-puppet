# == Class: straycat::os::pkgrepos::foreman
#
# Add Foreman repo.
#
# === Parameters
#
# [*enabled*]
#   If the repo should be enabled.
#
# === Examples
#
#   class { '::straycat::os::pkgrepos::foreman': }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os::pkgrepos::foreman (
  $enabled = true
) {

  if $enabled == true {
    $repo_enabled = '1'
  } else {
    $repo_enabled = '0'
  }

  # FIXME: move to hiera
  $release = '1.7'

  anchor { 'straycat::os::pkgrepos::foreman::start': }

  yumrepo { 'foreman':
    descr    => "Foreman - ${release}",
    baseurl  => "http://yum.theforeman.org/releases/${release}/${::centos_pkg_release}/\$basearch",
    enabled  => $repo_enabled,
    gpgcheck => '1',
    gpgkey   => "http://yum.theforeman.org/releases/${release}/RPM-GPG-KEY-foreman",
    notify   => Straycat::Os::Pkgrepos::Repo_clean['foreman']
  }

  straycat::os::pkgrepos::repo_clean{ 'foreman': }

  yumrepo { 'foreman-plugins':
    descr    => "Foreman plugins - ${release}",
    baseurl  => "http://yum.theforeman.org/plugins/${release}/${::centos_pkg_release}/\$basearch",
    enabled  => $repo_enabled,
    gpgcheck => '1',
    gpgkey   => "http://yum.theforeman.org/releases/${release}/RPM-GPG-KEY-foreman",
    notify   => Straycat::Os::Pkgrepos::Repo_clean['foreman-plugins']
  }

  straycat::os::pkgrepos::repo_clean{ 'foreman-plugins': }

  anchor { 'straycat::os::pkgrepos::foreman::end':
    require => [Anchor['straycat::os::pkgrepos::foreman::start'],
                Straycat::Os::Pkgrepos::Repo_clean['foreman'],
                Straycat::Os::Pkgrepos::Repo_clean['foreman-plugins'],]
  }

}
