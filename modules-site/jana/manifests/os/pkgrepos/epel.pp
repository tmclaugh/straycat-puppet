# == Class: jana::os::pkgrepos::epel
#
# Configure the EPEL yum repo.
#
# === Parameters
#
# [*enabled*]
#   If EPEL repo should be enabled.
#   Type: bool
#
# === Examples
#
# class { '::jana::os::pkgrepos::epel' }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::os::pkgrepos::epel (
  $enabled    = true,
) {

  anchor { 'jana::os::pkgrepos::epel::start': }

  if $enabled == true {
    $repo_enabled = '1'
  } else {
    $repo_enabled = '0'
  }

  yumrepo { 'epel':
    descr           => "Extra Packages for Enterprise Linux ${::centos_major} - ${::architecture}",
    baseurl         => "http://download.fedoraproject.org/pub/epel/\$releasever/\$basearch",
    #mirrorlist      => 'https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=$basearch',
    failovermethod  => 'priority',
    enabled         => $repo_enabled,
    gpgcheck        => 1,
    gpgkey          => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::centos_major}",
    notify          => Jana::Os::Pkgrepos::Repo_clean['epel']
  }

  jana::os::pkgrepos::repo_clean{ 'epel': }

  anchor { 'jana::os::pkgrepos::epel::end':
    require => [Anchor['jana::os::pkgrepos::epel::start'],
                Jana::Os::Pkgrepos::Repo_clean['epel']]
  }

}
