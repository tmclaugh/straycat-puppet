# == Class: jana::os::pkgrepos::centos
#
# Configure the CentOS yum repo.
#
# === Parameters
#
# [*base_repo_enabled*]
#   Enable base CentOS repo.
#   Type: bool
#
# [*updates_repo_enabled*]
#   Enable updates CentOS repo.
#   Type: bool
#
# === Examples
#
# class { '::jana::os::pkgrepos::centos' }
#
# === Authors
#
# Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# === Copyright
#
# Copyright 2014 Tom McLaughlin
#
class jana::os::pkgrepos::centos (
  $base_repo_enabled    = true,
  $updates_repo_enabled = true,
) {

  anchor { 'jana::os::pkgrepos::centos::start': }

  exec { 'yum-centos-repo-rm':
    command => 'rm /etc/yum.repos.d/CentOS-*.repo',
    path    => ['/bin', '/usr/bin'],
    unless  => 'test -z "$(ls /etc/yum.repos.d/CentOS-*.repo)"'
  }

  yumrepo { 'centos-base':
    descr          => "CentOS-${::centos_major}-${::architecture} Base",
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra',
    failovermethod => 'priority',
    enabled        => $base_repo_enabled,
    gpgcheck       => 1,
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::centos_major}",
    notify         => Jana::Os::Pkgrepos::Repo_clean['centos-base'],
    require        => Exec['yum-centos-repo-rm']
  }

  yumrepo { 'centos-updates':
    descr          => "CentOS-${::centos_major}-${::architecture} Updates",
    mirrorlist     => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra',
    failovermethod => 'priority',
    enabled        => $updates_repo_enabled,
    gpgcheck       => 1,
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::centos_major}",
    notify         => Jana::Os::Pkgrepos::Repo_clean['centos-base'],
    require        => Exec['yum-centos-repo-rm']
  }

  jana::os::pkgrepos::repo_clean{ 'centos-base': }
  jana::os::pkgrepos::repo_clean{ 'centos-updates': }

  jana::os::pkgrepos::repo_makecache{ 'centos-base': }
  jana::os::pkgrepos::repo_makecache{ 'centos-updates': }

  Jana::Os::Pkgrepos::Repo_clean['centos-base']    ~> Jana::Os::Pkgrepos::Repo_makecache['centos-base']
  Jana::Os::Pkgrepos::Repo_clean['centos-updates'] ~> Jana::Os::Pkgrepos::Repo_makecache['centos-updates']

  anchor { 'jana::os::pkgrepos::centos::end':
    require => [Jana::Os::Pkgrepos::Repo_clean['centos-base'],
                Jana::Os::Pkgrepos::Repo_clean['centos-updates'],
                Jana::Os::Pkgrepos::Repo_makecache['centos-base'],
                Jana::Os::Pkgrepos::Repo_makecache['centos-updates']]
  }
}
