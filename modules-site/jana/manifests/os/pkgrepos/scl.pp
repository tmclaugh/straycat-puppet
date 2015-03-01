# == Class: jana::os::pkgrepos::scl
#
# Add RedHat SCL repo.
#
# === Parameters
#
# [*enabled*]
#   If the repo should be enabled.
#
# === Examples
#
#   class { '::jana::os::pkgrepos::scl': }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::os::pkgrepos::scl (
  $enabled = true
) {

  if $enabled == true {
    $repo_enabled = '1'
  } else {
    $repo_enabled = '0'
  }

  anchor { 'jana::os::pkgrepos::scl::start': }

  yumrepo { 'scl':
    descr           => 'CentOS-\$releasever - SCL',
    baseurl         => 'http://mirror.centos.org/centos/$releasever/SCL/$basearch/',
    enabled         => $repo_enabled,
    gpgcheck        => '1',
    gpgkey          => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${::centos_major}",
    notify          => Jana::Os::Pkgrepos::Repo_clean['scl']
  }

  jana::os::pkgrepos::repo_clean{ 'scl': }

  anchor { 'jana::os::pkgrepos::scl::end':
    require => [Anchor['jana::os::pkgrepos::scl::start'],
                Jana::Os::Pkgrepos::Repo_clean['scl']]
  }

}
