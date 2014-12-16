# == Class: straycat::os::pkgrepos::scl
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
#   class { '::straycat::os::pkgrepos::scl': }
#
# === Authors
#
# tmclaugh@sdf.lonestar.org
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class straycat::os::pkgrepos::scl (
  $enabled = true
) {

  if $enabled == true {
    $repo_enabled = '1'
  } else {
    $repo_enabled = '0'
  }

  anchor { 'straycat::os::pkgrepos::scl::start': }

  yumrepo { 'scl':
    descr           => 'CentOS-\$releasever - SCL',
    baseurl         => 'http://mirror.centos.org/centos/$releasever/SCL/$basearch/',
    enabled         => $repo_enabled,
    gpgcheck        => '1',
    gpgkey          => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${::centos_major}",
    notify          => Straycat::Os::Pkgrepos::Repo_clean['scl']
  }

  straycat::os::pkgrepos::repo_clean{ 'scl': }

  anchor { 'straycat::os::pkgrepos::scl::end':
    require => [Anchor['straycat::os::pkgrepos::scl::start'],
                Straycat::Os::Pkgrepos::Repo_clean['scl']]
  }

}
